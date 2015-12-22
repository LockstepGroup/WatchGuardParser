function Get-WgPolicy {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgPolicy: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($Policy in $ConfigContents.profile.'policy-list'.policy) {
		$NewPolicy              = New-Object WatchGuardParser.Policy
		$NewPolicy.Name         = $Policy.name
		$NewPolicy.Description  = $Policy.description
		$NewPolicy.Property     = $Policy.property
		$NewPolicy.Service      = $Policy.service
		$NewPolicy.Firewall     = $Policy.firewall
		$NewPolicy.RejectAction = $Policy.'reject-action'
		
		$ReturnObject           += $NewPolicy		
	}
	
	return $ReturnObject
	
}