function HelperCloneCustomType {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[object]$Object,
		
		[Parameter(Mandatory=$False,Position=1)]
		[array]$AddProperties
	)
	
	$VerbosePrefix = "HelperCloneCustomType: "
	
	$Type         = $Object.GetType().FullName
	$Properties   = $Object | gm -Type *Property
	$ValidProperties = @()
	
	foreach ($p in $Properties) {
		$ValidProperties += "$($p.Name)"
	}
	
	if ($AddProperties) {
		$ValidProperties += ( $AddProperties | ? { $ValidProperties -notcontains $_ } )
	}
	
    Write-Verbose "$VerbosePrefix $($ValidProperties -join ',')"
    
	$ReturnObject = "" | Select $ValidProperties
	
	foreach ($p in $Properties) {
		$ReturnObject."$($p.Name)" = $Object."$($p.Name)"
	}
	
	return $ReturnObject
}