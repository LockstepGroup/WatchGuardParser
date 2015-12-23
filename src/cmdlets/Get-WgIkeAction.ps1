function Get-WgIkeAction {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgIkeAction: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($IkeAction in $ConfigContents.profile.'ike-action-list'.'ike-action') {
		$NewIkeAction             = New-Object WatchGuardParser.IkeAction
		$NewIkeAction.Name        = $IkeAction.name
		$NewIkeAction.Description = $IkeAction.description
		$NewIkeAction.Property    = $IkeAction.property
        $NewIkeAction.Mode        = $IkeAction.mode
        
        $NewIkeAction.NatTEnabled            = $IkeAction.'nat-t-config'.'nat-t-enabled'
        $NewIkeAction.NatTKeepAlive          = $IkeAction.'nat-t-config'.'nat-t-keep-alive'
        $NewIkeAction.NatTFromPort           = $IkeAction.'nat-t-config'.'nat-t-from-port'
        $NewIkeAction.NatTToPort             = $IkeAction.'nat-t-config'.'nat-t-to-port'
        $NewIkeAction.NatTUdpChecksumEnabled = $IkeAction.'nat-t-config'.'nat-t-udp-checksum-enabled'
        
        $NewIkeAction.Pfs          = $IkeAction.pfs
        $NewIkeAction.Xauth        = $IkeAction.xauth
        $NewIkeAction.RasUserGroup = $IkeAction.'ras-user-group-name'
        
        foreach ($Transform in $IkeAction.'ike-transform'.member) {
            $NewTransform                   = New-Object WatchGuardParser.IkeTransform
            $NewTransform.Description       = $Transform.description
            $NewTransform.AuthMethod        = $Transform.'auth-method'
            $NewTransform.DhGroup           = $Transform.'dh-group'
            $NewTransform.EncryptAlgorithm  = $Transform.'encryp-algm'
            $NewTransform.AuthAlgorithm     = $Transform.'auth-algm'
            $NewTransform.TimeUnit          = $Transform.'time-unit'
            $NewTransform.LifeTime          = $Transform.'lifetime'
            $NewTransform.LifeLength        = $Transform.'life-length'
            $NewIkeAction.IkeTransforms    += $NewTransform
        }

		$ReturnObject           += $NewIkeAction
		
	}
	
	return $ReturnObject
	
}

