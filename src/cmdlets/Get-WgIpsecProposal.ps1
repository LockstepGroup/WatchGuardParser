function Get-WgIpsecProposal {
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
	
	$VerbosePrefix = "Get-WgIpsecProposal: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($IpsecProposal in $ConfigContents.profile.'ipsec-proposal-list'.'ipsec-proposal') {
		$NewIpsecProposal                  = New-Object WatchGuardParser.IpsecProposal
		$NewIpsecProposal.Name             = $IpsecProposal.name
		$NewIpsecProposal.Description      = $IpsecProposal.description
		$NewIpsecProposal.Property         = $IpsecProposal.property
        $NewIpsecProposal.AntiReplayWindow = $IpsecProposal.'anti-reply-window'
        $NewIpsecProposal.Type             = $IpsecProposal.type
        
        foreach ($Member in $IpsecProposal.'esp-transform'.member) {
            $NewMember                       = New-Object WatchGuardParser.EspTransform
            $NewMember.EncryptAlgorithm      = $Member.'encryp-algm'
            $NewMember.AuthAlgorithm         = $Member.'auth-algm'
            $NewMember.TimeUnit              = $Member.'time-unit'
            $NewMember.LifeTime              = $Member.'lifetime'
            $NewMember.LifeLength            = $Member.'life-length'
            $NewMember.AuthkeyLength         = $Member.'auth-key-length'
            $NewMember.EncryptKeyLength      = $Member.'encryp-key-length'
            $NewIpsecProposal.EspTransforms += $NewMember
        }

		$ReturnObject           += $NewIpsecProposal
		
	}
	
	if ($Name) {
        return ($ReturnObject | ? { $_.Name -eq $Name })
    } else {
	   return $ReturnObject
    }
}

