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
            switch ($Field) {
                { $_ -match "alias" } {
                    $NewFieldPrefix = $Field -replace 'aliaslist',''
                    
                    $AliasFields = @("User"
                                     "Address"
                                     "Interface"
                                     "AliasName")
                    $NewFields = @()
                    foreach ($a in $AliasFields) { $NewFields += "$NewFieldPrefix$a" }
                    
                    $ResolvedAlias = Resolve-WgAlias $p.$Field $LookupTable
                    foreach ($Result in $ResolvedAlias) {
                        $NewPolicy = HelperCloneCustomType $p $NewFields
                        foreach ($a in $AliasFields) {
                            $NewPolicy."$NewFieldPrefix$a" = $Result.$a
                        }
                        $ReturnObject += $NewPolicy
                    }
                }
                default { Throw "VerbosePrefix Field not handled: $Field" }
            }
		} else {
			$ReturnObject += HelperCloneCustomType $p
		}
	}
	
	return $ReturnObject
	
}