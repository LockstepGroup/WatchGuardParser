function Resolve-WgPolicy {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$Policies,
		
		[Parameter(Mandatory=$True,Position=1)]
		[string]$Field,
		
		[Parameter(Mandatory=$True,Position=2)]
		[array]$LookupTable
	)
	
	$VerbosePrefix = "Resolve-WgPolicy: "
	$ReturnObject  = @()
	
	foreach ($p in $Policies) {
		if ($p.$Field) {
            
		} else {
			$ReturnObject += HelperCloneCustomType $p
		}
	}
	
	return $ReturnObject
	
}