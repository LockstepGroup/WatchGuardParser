function Resolve-WgAuthGroup {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[string]$Name,
		
		[Parameter(Mandatory=$True,Position=1)]
		[array]$AuthGroups
	)
	
	$VerbosePrefix = "Resolve-WgAuthGroup: "
	$ReturnObject  = @()
	
	$Lookup = $AuthGroups | ? { $_.Name -eq $Name }
	if ($Lookup) {
        switch ($Lookup.AuthGroupType) {
            2 { 
                $ReturnObject += $Lookup.AuthDomain + '\' + $Lookup.MembershipId
            }
            3 { $ReturnObject += Resolve-WgAuthGroup $Lookup.AuthGroupName $AuthGroups }
            default { Throw "$VerbosePrefix AuthGroup Type unknown: $($Member.Type)" }
        }
	} else {
		Throw "$VerbosePrefix AuthGroup not found: $Name"
	}
	
	return $ReturnObject
	
}