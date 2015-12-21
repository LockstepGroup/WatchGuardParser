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