function Get-WgAuthGroup {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgAuthGroup: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($AuthGroup in $ConfigContents.profile.'auth-group-list'.'auth-group') {
		$NewAuthGroup             = New-Object WatchGuardParser.AuthGroup
		$NewAuthGroup.Name        = $AuthGroup.name
		$NewAuthGroup.Description = $AuthGroup.description
		$NewAuthGroup.Property    = $AuthGroup.property
        $NewAuthGroup.EnableLogin = $AuthGroup.'enable-login-setting'
        
        $NewAuthGroup.AuthGroupType = $AuthGroup.'auth-group-item'.item.type
        $NewAuthGroup.MembershipId  = $AuthGroup.'auth-group-item'.item.'membership-id'
        $NewAuthGroup.AuthDomain    = $AuthGroup.'auth-group-item'.item.'auth-domain'
        $NewAuthGroup.AuthGroupname = $AuthGroup.'auth-group-item'.item.'auth-group-name'
        
		$ReturnObject += $NewAuthGroup		
	}
	
	return $ReturnObject
	
}