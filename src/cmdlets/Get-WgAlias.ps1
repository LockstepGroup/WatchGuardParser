function Get-WgAlias {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgAlias: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($Alias in $ConfigContents.profile.'alias-list'.alias) {
		$NewAlias              = New-Object WatchGuardParser.Alias
		$NewAlias.Name         = $Alias.Name
		$NewAlias.Description  = $Alias.description
		$NewAlias.Property     = $Alias.Property
		
		$ReturnObject         += $NewAlias
		
		foreach ($Member in $Alias.'alias-member-list'.'alias-member') {
			$NewMember            = New-Object WatchGuardParser.alias-member
			$NewMember.Type       = $Member.type
			$NewMember.User       = $Member.user
			$NewMember.Address    = $Member.address
			$NewMember.Interface  = $Member.interface
			$NewAlias.Members    += $NewMember
		}
	}
	
	return $ReturnObject
	
}