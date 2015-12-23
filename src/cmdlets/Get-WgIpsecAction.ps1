function Get-WgIpsecAction {
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
	
	$VerbosePrefix = "Get-WgIpsecAction: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($IpsecAction in $ConfigContents.profile.'ipsec-action-list'.'ipsec-action') {
		$NewIpsecAction             = New-Object WatchGuardParser.IpsecAction
		$NewIpsecAction.Name        = $IpsecAction.name
		$NewIpsecAction.Description = $IpsecAction.description
		$NewIpsecAction.Property    = $IpsecAction.property
        $NewIpsecAction.Mode        = $IpsecAction.mode
        $NewIpsecAction.KeyMode     = $IpsecAction.keymode

		$NewIpsecAction.UseAnyForService       = $IpsecAction.'vpn-tunnel-sharing'.'use-any-for-service'
        $NewIpsecAction.UseAnyForAddress      = $IpsecAction.'vpn-tunnel-sharing'.'use-any-for-address'
        $NewIpsecAction.UseAnyForLocalAddress  = $IpsecAction.'vpn-tunnel-sharing'.'use-any-for-local-address'
        $NewIpsecAction.UseAnyForRemoteAddress = $IpsecAction.'vpn-tunnel-sharing'.'use-any-for-remote-address'
        $NewIpsecAction.SharingAcrossPolicy    = $IpsecAction.'vpn-tunnel-sharing'.'sharing-across-policy'
        
        $NewIpsecAction.UseLocalRemotePair    = $IpsecAction.'use-local-remote-pair'
        
        foreach ($Pair in $IpsecAction.'local-remote-pair-list'.'local-remote-pair') {
            $NewPair                             = New-Object WatchGuardParser.LocalRemotePair
            $NewPair.LocalAddress                = $Pair.'local-addr'
            $NewPair.RemoteAddress               = $Pair.'remote-addr'
            $NewPair.Direction                   = $Pair.'direction'
            $NewPair.Nat                         = $Pair.'nat'
            $NewIpsecAction.LocalRemotePairList += $NewPair
        }
        
        $NewIpsecAction.IkePolicy      = $IpsecAction.'ike-policy'
        $NewIpsecAction.IkePolicyGroup = $IpsecAction.'ike-policy-group'
        $NewIpsecAction.Pfs            = $IpsecAction.'pfs'
        $NewIpsecAction.DhGroup        = $IpsecAction.'dh-group'
        
        $NewIpsecAction.IpsecProposal   = $IpsecAction.'ipsec-proposal'.'member'
        
        $NewIpsecAction.Enabled   = $IpsecAction.'enabled'

		$ReturnObject           += $NewIpsecAction
		
	}
	
    if ($Name) {
        return ($ReturnObject | ? { $_.Name -eq $Name })
    } else {
	   return $ReturnObject
    }
}

