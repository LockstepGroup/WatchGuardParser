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
		$NewNat                  = New-Object WatchGuardParser.FirewallPolicy
		$NewNat.Name             = $Nat.Name
		$NewNat.Description      = $Nat.description
		$NewNat.Property         = $Nat.Property
		$NewNat.Type             = $Nat.type
		$NewNat.Algorithm        = $Nat.algorithm
		$NewNat.ProxyArp         = $Nat.'proxy-arp'
		
		if ($Nat.'nat-item'.member) {
			$NewNat.AddressType      = @($Nat.'nat-item'.member)[0].'addr-type'
			$NewNat.Port             = @($Nat.'nat-item'.member)[0].'port'
			$NewNat.ExternalAddress  = @($Nat.'nat-item'.member)[0].'ext-addr-name'
			$NewNat.Interface        = @($Nat.'nat-item'.member)[0].'interface'
			$NewNat.Address          = @($Nat.'nat-item'.member)[0].'addr-name'
		}
		
		$ReturnObject           += $NewNat
		
	}
	
	return $ReturnObject
	
}