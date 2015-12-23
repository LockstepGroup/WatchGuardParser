function Get-WgIkePolicy {
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
	
	foreach ($IkePolicy in $ConfigContents.profile.'ike-policy-list'.'ike-policy') {
		$NewIpsecAction             = New-Object WatchGuardParser.IkePolicy
		$NewIpsecAction.Name        = $IkePolicy.name
		$NewIpsecAction.Description = $IkePolicy.description
		$NewIpsecAction.Property    = $IkePolicy.property
        $NewIpsecAction.Enabled     = $IkePolicy.enabled
        
        $NewIpsecAction.PeerAddress = $IkePolicy.'peer-addr'
        $NewIpsecAction.IkeAction   = $IkePolicy.'ike-action'
        
        $NewIpsecAction.KeepAliveInterval = $IkePolicy.'keep-alive-interval'
        $NewIpsecAction.KeepAliveMax      = $IkePolicy.'keep-alive-max'
        
        $NewIpsecAction.DpdEnabled     = $IkePolicy.'dpd-enabled'
        $NewIpsecAction.DpdMaxFailure  = $IkePolicy.'dpd-max-failure'
        $NewIpsecAction.DpdWorryMetric = $IkePolicy.'dpd-worry-metric'
        
        $NewIpsecAction.VpnType   = $IkePolicy.'vpn-type'
        $NewIpsecAction.AutoStart = $IkePolicy.'auto-start'
        
        $NewIpsecAction.PeerAuthMask = $IkePolicy.'peer-auth'.'peer-auth-mask'
        $NewIpsecAction.PeerAuthIp   = $IkePolicy.'peer-auth'.'ip-addr'
        
        $NewIpsecAction.RsaCert   = $IkePolicy.'local-cert'.'rsa-cert'
        $NewIpsecAction.RsaIdType = $IkePolicy.'local-cert'.'rsa-id-type'
        $NewIpsecAction.DsaCert   = $IkePolicy.'local-cert'.'dsa-cert'
        $NewIpsecAction.DsaIdType = $IkePolicy.'local-cert'.'dsa-id-type'
        $NewIpsecAction.Psk       = $IkePolicy.'local-cert'.'psk'
        $NewIpsecAction.PskHex    = $IkePolicy.'local-cert'.'psk-hex'
        
        $NewIpsecAction.LocalIdType    = $IkePolicy.'local-cert'.'local-id-type'
        $NewIpsecAction.LocalIdData    = $IkePolicy.'local-cert'.'local-id-data'
        $NewIpsecAction.LocalInterface = $IkePolicy.'local-cert'.'local-if'
        
		$ReturnObject           += $NewIpsecAction
		
	}
	
	if ($Name) {
        return ($ReturnObject | ? { $_.Name -eq $Name })
    } else {
	   return $ReturnObject
    }
}

