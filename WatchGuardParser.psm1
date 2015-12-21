###############################################################################
## Start Powershell Cmdlets
###############################################################################

###############################################################################
# Get-WgAddressGroup

function Get-WgAddressGroup {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgAddressGroup: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($Group in $ConfigContents.profile.'address-group-list'.'address-group') {
		$NewAddressGroup              = New-Object WatchGuardParser.AddressGroup
		$NewAddressGroup.Name         = $Group.Name
		$NewAddressGroup.Property     = $Group.Property
		$NewAddressGroup.Description  = $Group.description
		$ReturnObject                += $NewAddressGroup
		
		foreach ($Member in $Group.'addr-group-member'.member) {
			switch ($Member.Type) {
				1 {
					$NewAddressGroup.Members += $Member.'host-ip-addr' + '/32'
				}
				2 {
					$NewAddressGroup.Members += $Member.'ip-network-addr' + '/' + (ConvertTo-MaskLength $Member.'ip-mask')
				}
				3 {
					$NewAddressGroup.Members += $Member.'start-ip-addr' + '-' + $Member.'end-ip-addr'
				}
				default {
					Write-Verbose "$($NewAddressGroup.Name) member type ($($Member.Type)) not found"
				}
			}
		}
	}
	
	return $ReturnObject
	
}

###############################################################################
# Get-WgService

function Get-WgService {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgService: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
		
	$IpProtocols = @{}
	$IpProtocols."6"  = "tcp"
	$IpProtocols."17" = "udp"
	$IpProtocols."0"  = "0"
	$IpProtocols."47" = "GRE"
	$IpProtocols."2"  = "IGMP"
	$IpProtocols."50" = "ESP"
	$IpProtocols."51" = "AH"
	$IpProtocols."89" = "OSPF"
	$IpProtocols."1"  = "ICMP"
			
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($Service in $ConfigContents.profile.'service-list'.'service') {
		$NewService              = New-Object WatchGuardParser.Service
		$NewService.Name         = $Service.name
		$NewService.Property     = $Service.property
		$NewService.Description  = $Service.description
		$NewService.ProxyType    = $Service.'proxy-type'
		$NewService.IdleTimeout  = $Service.'idle-timeout'
		$ReturnObject           += $NewService
		
		foreach ($Member in $Service.'service-item'.member) {
			$Protocol = $IpProtocols."$($Member.Protocol)"
			if (!($Protocol)) { Write-Verbose "Protocol not found: $($Member.Protocol)" }
			switch ($Member.Type) {
				1 {
					$NewService.Members += "$Protocol/" + $Member.'server-port'
				}
				2 {
					$NewService.Members += $Protocol + '/' + $Member.'start-server-port' + '-' + $Member.'end-server-port'
				}
				default {
					Write-Verbose "$($NewService.Name) member type ($($Member.Type)) not found"
				}
			}
		}
	}
	
	return $ReturnObject
	
}

###############################################################################
## Start Helper Functions
###############################################################################

###############################################################################
# HelperDetectClassful

function HelperDetectClassful {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True,Position=0,ParameterSetName='RxString')]
		[ValidatePattern("(\d+\.){3}\d+")]
		[String]$IpAddress
	)
	
	$VerbosePrefix = "HelperDetectClassful: "
	
	$Regex = [regex] "(?x)
					  (?<first>\d+)\.
					  (?<second>\d+)\.
					  (?<third>\d+)\.
					  (?<fourth>\d+)"
						  
	$Match = HelperEvalRegex $Regex $IpAddress
	
	$First  = $Match.Groups['first'].Value
	$Second = $Match.Groups['second'].Value
	$Third  = $Match.Groups['third'].Value
	$Fourth = $Match.Groups['fourth'].Value
	
	$Mask = 32
	if ($Fourth -eq "0") {
		$Mask -= 8
		if ($Third -eq "0") {
			$Mask -= 8
			if ($Second -eq "0") {
				$Mask -= 8
			}
		}
	}
	
	return "$IpAddress/$([string]$Mask)"
}

###############################################################################
# HelperEvalRegex

function HelperEvalRegex {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True,Position=0,ParameterSetName='RxString')]
		[String]$RegexString,
		
		[Parameter(Mandatory=$True,Position=0,ParameterSetName='Rx')]
		[regex]$Regex,
		
		[Parameter(Mandatory=$True,Position=1)]
		[string]$StringToEval,
		
		[Parameter(Mandatory=$False)]
		[string]$ReturnGroupName,
		
		[Parameter(Mandatory=$False)]
		[int]$ReturnGroupNumber,
		
		[Parameter(Mandatory=$False)]
		$VariableToUpdate,
		
		[Parameter(Mandatory=$False)]
		[string]$ObjectProperty,
		
		[Parameter(Mandatory=$False)]
		[string]$LoopName
	)
	
	$VerbosePrefix = "HelperEvalRegex: "
	
	if ($RegexString) {
		$Regex = [Regex] $RegexString
	}
	
	if ($ReturnGroupName) { $ReturnGroup = $ReturnGroupName }
	if ($ReturnGroupNumber) { $ReturnGroup = $ReturnGroupNumber }
	
	$Match = $Regex.Match($StringToEval)
	if ($Match.Success) {
		#Write-Verbose "$VerbosePrefix Matched: $($Match.Value)"
		if ($ReturnGroup) {
			#Write-Verbose "$VerbosePrefix ReturnGroup"
			switch ($ReturnGroup.Gettype().Name) {
				"Int32" {
					$ReturnValue = $Match.Groups[$ReturnGroup].Value.Trim()
				}
				"String" {
					$ReturnValue = $Match.Groups["$ReturnGroup"].Value.Trim()
				}
				default { Throw "ReturnGroup type invalid" }
			}
			if ($VariableToUpdate) {
				if ($VariableToUpdate.Value.$ObjectProperty) {
					#Property already set on Variable
					continue $LoopName
				} else {
					$VariableToUpdate.Value.$ObjectProperty = $ReturnValue
					Write-Verbose "$ObjectProperty`: $ReturnValue"
				}
				continue $LoopName
			} else {
				return $ReturnValue
			}
		} else {
			return $Match
		}
	} else {
		if ($ObjectToUpdate) {
			return
			# No Match
		} else {
			return $false
		}
	}
}

###############################################################################
# HelperTestVerbose

function HelperTestVerbose {
[CmdletBinding()]
param()
    [System.Management.Automation.ActionPreference]::SilentlyContinue -ne $VerbosePreference
}

###############################################################################
## Export Cmdlets
###############################################################################

Export-ModuleMember *-*
