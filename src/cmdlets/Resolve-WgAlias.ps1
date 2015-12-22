function Resolve-WgAlias {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[string]$Name,
		
		[Parameter(Mandatory=$True,Position=1)]
		[array]$Aliases
	)
	
	$VerbosePrefix = "Resolve-WgAlias: "
	$ReturnObject  = @()
	
	$Lookup = $Aliases | ? { $_.Name -eq $Name }
	if ($Lookup) {
		foreach ($Member in $Lookup.Members) {
			switch ($Member.Type) {
				1 { 
					$ReturnObject += $Member
				}
				2 { $ReturnObject += Resolve-WgAlias $Member.AliasName $Aliases }
				default { Throw "Alias Type unknow: $($Member.Type)" }
			}
		}
	} else {
		Throw "Alias not found: $Name"
	}
	
	return $ReturnObject
	
}