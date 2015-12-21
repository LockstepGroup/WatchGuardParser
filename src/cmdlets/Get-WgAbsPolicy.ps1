function Get-WgAbsPolicy {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgAbsPolicy: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($Policy in $ConfigContents.profile.'abs-policy-list'.'abs-policy') {
		$NewPolicy                  = New-Object WatchGuardParser.AbsPolicy
		$NewPolicy.Name             = $Policy.Name
		$NewPolicy.Description      = $Policy.description
		$NewPolicy.Property         = $Policy.Property
		$NewPolicy.Type         = $Policy.type
		$NewPolicy.TrafficType         = $Policy.'traffic-type'
		
		switch ($Policy.enabled) {
			true    { $NewPolicy.Enabled = $true }
			false   { $NewPolicy.Enabled = $false }
			default { Write-Verbose "Enabled value of $($Policy.enabled) undefined" }
		}
		
		$NewPolicy.Firewall = $Policy.firewall
		$NewPolicy.RejectAction = $Policy.'reject-action'
		
		$NewPolicy.FromAliasList = $Policy.'from-alias-list'.alias
		$NewPolicy.ToAliasList   = $Policy.'to-alias-list'.alias
		
		$NewPolicy.PolicyNat = $Policy.'policy-nat'
		
		# Settings
		$NewPolicy.Proxy = $Policy.settings.proxy
		
		$NewPolicy.Nat1To1         = $Policy.settings.'apply-one-to-one-nat-rules'
		$NewPolicy.ApplyDnatGlobal = $Policy.settings.'apply-dnat-global'
		$NewPolicy.DNatAllTraffic  = $Policy.settings.'apply-dnat-all-traffic'
		$NewPolicy.DNatSource      = $Policy.settings.'dnat-src-ip'
			
		$NewPolicy.TrafficMgmt      = $Policy.settings.'traffic-mgmt'
		$NewPolicy.ConnectionRate      = $Policy.settings.'connection-rate'
		$NewPolicy.ConnectionRateAlarm      = $Policy.settings.'connection-rate-alarm'
			
		$NewPolicy.QosField    = $Policy.settings.'qos-marking'.'marking-field'
		$NewPolicy.QosMethod   = $Policy.settings.'qos-marking'.'marking-method'.'marking-type'
		$NewPolicy.QosPriority = $Policy.settings.'qos-marking'.'priority-method'
			
		$NewPolicy.Schedule      = $Policy.settings.schedule
		
		switch ($Policy.settings.'auto-block-enabled') {
			true    { $NewPolicy.AutoBlockEnabled = $true }
			false   { $NewPolicy.AutoBlockEnabled = $false }
			default { Write-Verbose ("$($NewPolicy.Name): auto-block-enabled value of " + $Policy.settings.'auto-block-enabled' + " undefined") }
		}
		
		switch ($Policy.settings.'log-enabled') {
			true    { $NewPolicy.LogEnabled = $true }
			false   { $NewPolicy.LogEnabled = $false }
			default { Write-Verbose ("$($NewPolicy.Name): log-enabled value of " + $Policy.settings.'log-enabled' + " undefined") }
		}
		
		switch ($Policy.settings.'snmp-enabled') {
			true    { $NewPolicy.SnmpEnabled = $true }
			false   { $NewPolicy.SnmpEnabled = $false }
			default { Write-Verbose ("$($NewPolicy.Name): snmp-enabled value of " + $Policy.settings.'snmp-enabled' + " undefined") }
		}
		
		switch ($Policy.settings.'notification-enabled') {
			true    { $NewPolicy.NotificationEnabled = $true }
			false   { $NewPolicy.NotificationEnabled = $false }
			default { Write-Verbose ("$($NewPolicy.Name): notification-enabled value of " + $Policy.settings.'notification-enabled' + " undefined") }
		}
		
		$NewPolicy.PolicyRouting = $Policy.settings.'policy-routing'
			
		switch ($Policy.settings.'ips-monitor-enabled') {
			true    { $NewPolicy.IpsMonitorEnabled = $true }
			false   { $NewPolicy.NotificationEnabled = $false }
			default { Write-Verbose ("$($NewPolicy.Name): ips-monitor-enabled value of " + $Policy.settings.'ips-monitor-enabled' + " undefined") }
		}
		
		$NewPolicy.IdleTimeout = $Policy.settings.'idle-timeout'
		$NewPolicy.UseGlobalSticky = $Policy.settings.'using-global-sticky-setting'
		$NewPolicy.StickyTimer = $Policy.settings.'policy-sticky-timer'
			
		$NewPolicy.PolicyList = $Policy.'policy-list'.policy
			
		$ReturnObject           += $NewPolicy
		
	}
	
	return $ReturnObject
	
}
