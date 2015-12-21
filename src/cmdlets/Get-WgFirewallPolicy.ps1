function Get-WgFirewallPolicy {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgFirewallPolicy: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($Policy in $ConfigContents.profile.'abs-policy-list'.'abs-policy') {
		$NewPolicy                  = New-Object WatchGuardParser.FirewallPolicy
		$NewPolicy.Name             = $Policy.Name
		$NewPolicy.Description      = $Policy.description
		$NewPolicy.Property         = $Policy.Property
		$NewPolicy.Type         = $Policy.type
		$NewPolicy.TrafficType         = $Policy.'traffic-type'
		
		switch ($Policy.enabled) {
			true    { $NewPolicy.Enabled = $true }
			false   { $NewPolicy.Enabled = $false }
			default { Write-Verbose "Enabled value of $($Policy.enabled) undefined" }
		}
		
		$NewPolicy.Firewall = $Policy.firewall
		$NewPolicy.RejectAction = $Policy.'reject-action'
		
		$NewPolicy.FromAliasList = $Policy.'from-alias-list'.alias
		$NewPolicy.ToAliasList   = $Policy.'to-alias-list'.alias
		
		$ReturnObject           += $NewPolicy
		
	}
	
	return $ReturnObject
	
}
