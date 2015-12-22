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
				foreach ($prop in $MemberProperties) {
#					if ($prop -match 'name') { continue }
					$NewProperties += "$NewPrefix$prop"
					Write-Verbose "$NewPrefix$prop"
				}
				
				$NewPolicy = HelperCloneCustomType $p $NewProperties
				$Global:NewPolicy = $NewPolicy
				
				foreach ($prop in $MemberProperties) {
#					if ($prop -match 'name') { continue }
					$NewPolicy."$NewPrefix$prop" = $m.$prop
				}
				$ReturnObject += $NewPolicy
			}
		} else {
			$ReturnObject += HelperCloneCustomType $p
		}
	}
	
	return $ReturnObject
	
}