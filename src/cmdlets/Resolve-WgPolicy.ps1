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
                                     "Interface")
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
                { $_ -match "address" } {
                    switch ($p.$Field) {
                        Any { $ReturnObject += HelperCloneCustomType $p }
                        default {
                            $Lookup = $LookupTable | ? { $_.Name -eq $p.$Field }
                            if ($Lookup) {
                                foreach ($m in $Lookup.Members) {
                                    $NewPolicy         = HelperCloneCustomType $p
                                    $NewPolicy.$Field  = $m
                                    $ReturnObject     += $NewPolicy
                                }
                            } else {
                                Throw "$VerbosePrefix Field Lookup failed: $Field`: $($p.$Field)"
                            }
                        } 
                    }
                }
                { $_ -match "user" } {
                    switch ($p.$Field) {
                        Any { $ReturnObject += HelperCloneCustomType $p }
                        default {
                            $NewPolicy         = HelperCloneCustomType $p
                            $NewPolicy.$Field  = Resolve-WgAuthGroup $p.$Field $LookupTable
                            $ReturnObject     += $NewPolicy
                        }
                    }
                }
                Service {
                    $Lookup = $LookupTable | ? { $_.Name -eq $p.$Field }
                    foreach ($Member in $Lookup.Members) {
                        $NewPolicy                  = HelperCloneCustomType $p ServiceResolved
                        $NewPolicy.ServiceResolved  = $Member
                        $ReturnObject              += $NewPolicy 
                    }
                }
                default { Throw "$VerbosePrefix Field not handled: $Field" }
            }
		} else {
			$ReturnObject += HelperCloneCustomType $p
		}
	}
	
	return $ReturnObject
	
}