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
			$Lookup = $LookupTable | ? { $_.Name -eq $p.$Field }
			$NewPrefix = $Field -replace 'aliaslist',''
			foreach ($m in $Lookup.Members) {
				$NewProperties = @()
				$MemberProperties = ($m | gm -type Property).Name
				foreach ($p in $MemberProperties) {
					if ($p -match 'name') { continue }
					$NewProperties += "$NewPrefix`$p"
				}
				
				$NewPolicy = HelperCloneCustomType $p $NewProperties
				
				foreach ($p in $NewProperties) {
					$NewPolicy.$p = $m.$p
				}
				$ReturnObject += $NewPolicy
			}
		} else {
			$ReturnObject += HelperCloneCustomType $p
		}
	}
	
	return $ReturnObject
	
}