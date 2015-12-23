function Get-WgIkePolicyGroup {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents,
        
        [Parameter(Mandatory=$False,Position=1)]
		[string]$Name
	)
	
	$VerbosePrefix = "Get-WgIkePolicyGroup: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($IkePolicyGroup in $ConfigContents.profile.'ike-policy-group-list'.'ike-policy-group') {
		$NewIkePolicyGroup              = New-Object WatchGuardParser.IkePolicyGroup
		$NewIkePolicyGroup.Name         = $IkePolicyGroup.name
		$NewIkePolicyGroup.Description  = $IkePolicyGroup.description
		$NewIkePolicyGroup.Property     = $IkePolicyGroup.property
        $NewIkePolicyGroup.Enabled      = $IkePolicyGroup.enabled
        
        foreach ($Member in $IkePolicyGroup.'member-list'.member) {
            $NewIkePolicyGroup.IkePolicies += $Member.'ike-policy'
        }    
        
		$ReturnObject                  += $NewIkePolicyGroup
	}
	
	if ($Name) {
        return ($ReturnObject | ? { $_.Name -eq $Name })
    } else {
	   return $ReturnObject
    }
}

