function Get-WgPolicy {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgPolicy: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($Policy in $ConfigContents.profile.'policy-list'.policy) {
		$NewPolicy              = New-Object WatchGuardParser.Policy
		$NewPolicy.Name         = $Policy.name
		$NewPolicy.Description  = $Policy.description
		$NewPolicy.Property     = $Policy.property
		$NewPolicy.Service      = $Policy.service
		$NewPolicy.Firewall     = $Policy.firewall
		$NewPolicy.RejectAction = $Policy.'reject-action'
			
		$NewPolicy.FromAliasList = $Policy.'from-alias-list'.alias
		$NewPolicy.ToAliasList   = $Policy.'to-alias-list'.alias
			
		$NewPolicy.Proxy       = $Policy.'proxy'
		$NewPolicy.TrafficMgmt = $Policy.'traffic-mgmt'
		
		$NewPolicy.QosField    = $Policy.'qos-marking'.'marking-field'
		$NewPolicy.QosMethod   = $Policy.'qos-marking'.'marking-method'.'marking-type'
		$NewPolicy.QosPriority = $Policy.'qos-marking'.'priority-method'
		
		$NewPolicy.Nat                 = $Policy.'nat'
		$NewPolicy.Schedule            = $Policy.'schedule'
		$NewPolicy.ConnectionRate      = $Policy.'connection-rate'
		$NewPolicy.ConnectionRateAlarm = $Policy.'connection-rate-alarm'
		
		$NewPolicy.Log               = $Policy.'log'
		$NewPolicy.Enable            = $Policy.'enable'
		$NewPolicy.IdleTimeout       = $Policy.'idle-timeout'
		$NewPolicy.UserFirewall      = $Policy.'user-firewall'
		$NewPolicy.IpsMonitorEnabled = $Policy.'ips-monitor-enabled'
			
		$NewPolicy.Alarm         = $Policy.'alarm'
		$NewPolicy.SendTcpReset  = $Policy.'send-tcp-reset'
		$NewPolicy.PolicyRouting = $Policy.'policy-routing'
			
		$NewPolicy.GlobalStickySetting = $Policy.'using-global-sticky-setting'
		$NewPolicy.PolicyStickyTimer   = $Policy.'policy-sticky-timer'
			
		$NewPolicy.Global1To1Nat = $Policy.'global-1to1-nat'
		$NewPolicy.GlobalDnat    = $Policy.'global-dnat'
		
		$ReturnObject           += $NewPolicy		
	}
	
	return $ReturnObject
	
}