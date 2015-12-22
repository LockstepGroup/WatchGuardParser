###############################################################################
## Start Powershell Cmdlets
###############################################################################

###############################################################################
# Get-WgAbsPolicy

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

###############################################################################
# Get-WgAddressGroup

function Get-WgAddressGroup {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgAddressGroup: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($Group in $ConfigContents.profile.'address-group-list'.'address-group') {
		$NewAddressGroup              = New-Object WatchGuardParser.AddressGroup
		$NewAddressGroup.Name         = $Group.Name
		$NewAddressGroup.Property     = $Group.Property
		$NewAddressGroup.Description  = $Group.description
		$ReturnObject                += $NewAddressGroup
		
		foreach ($Member in $Group.'addr-group-member'.member) {
			switch ($Member.Type) {
				1 {
					$NewAddressGroup.Members += $Member.'host-ip-addr' + '/32'
				}
				2 {
					$NewAddressGroup.Members += $Member.'ip-network-addr' + '/' + (ConvertTo-MaskLength $Member.'ip-mask')
				}
				3 {
					$NewAddressGroup.Members += $Member.'start-ip-addr' + '-' + $Member.'end-ip-addr'
				}
				default {
					Write-Verbose "$($NewAddressGroup.Name) member type ($($Member.Type)) not found"
				}
			}
		}
	}
	
	return $ReturnObject
	
}

###############################################################################
# Get-WgAlias

function Get-WgAlias {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgAlias: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($Alias in $ConfigContents.profile.'alias-list'.alias) {
		$NewAlias              = New-Object WatchGuardParser.Alias
		$NewAlias.Name         = $Alias.Name
		$NewAlias.Description  = $Alias.description
		$NewAlias.Property     = $Alias.Property
		
		$ReturnObject         += $NewAlias
		
		foreach ($Member in $Alias.'alias-member-list'.'alias-member') {
			$NewMember            = New-Object WatchGuardParser.AliasMember
			$NewMember.Type       = $Member.type
			$NewMember.User       = $Member.user
			$NewMember.Address    = $Member.address
			$NewMember.Interface  = $Member.interface
			$NewMember.AliasName  = $Member.'alias-name'
			$NewAlias.Members    += $NewMember
		}
	}
	
	return $ReturnObject
	
}

###############################################################################
# Get-WgAuthGroup

function Get-WgAuthGroup {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgAuthGroup: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($AuthGroup in $ConfigContents.profile.'auth-group-list'.'auth-group') {
		$NewAuthGroup             = New-Object WatchGuardParser.AuthGroup
		$NewAuthGroup.Name        = $AuthGroup.name
		$NewAuthGroup.Description = $AuthGroup.description
		$NewAuthGroup.Property    = $AuthGroup.property
        $NewAuthGroup.EnableLogin = $AuthGroup.'enable-login-setting'
        
        $NewAuthGroup.AuthGroupType = $AuthGroup.'auth-group-item'.item.type
        $NewAuthGroup.MembershipId  = $AuthGroup.'auth-group-item'.item.'membership-id'
        $NewAuthGroup.AuthDomain    = $AuthGroup.'auth-group-item'.item.'auth-domain'
        $NewAuthGroup.AuthGroupname = $AuthGroup.'auth-group-item'.item.'auth-group-name'
        
		$ReturnObject += $NewAuthGroup		
	}
	
	return $ReturnObject
	
}

###############################################################################
# Get-WgInterface

function Get-WgInterface {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgInterface: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($Interface in $ConfigContents.profile.'interface-list'.interface) {
		$NewInterface                  = New-Object WatchGuardParser.Interface
		$NewInterface.Name             = $Interface.name
		$NewInterface.Description      = $Interface.description
		$NewInterface.Property         = $Interface.property
		$NewInterface.ItemType         = $Interface.'if-item-list'.item.'item-type'
		
		$NewInterface.InterfaceNumber   = $Interface.'if-item-list'.item.'physical-if'.'if-num'
		$NewInterface.InterfaceName     = $Interface.'if-item-list'.item.'physical-if'.'if-dev-name'
		$NewInterface.InterfaceProperty = $Interface.'if-item-list'.item.'physical-if'.'if-property'
		$NewInterface.Enabled           = $Interface.'if-item-list'.item.'physical-if'.'enabled'
			
		$NewInterface.IpType          = $Interface.'if-item-list'.item.'physical-if'.'ip-node-type'
		
		$NewInterface.IpAddress       = $Interface.'if-item-list'.item.'physical-if'.'ip'
		if ($Interface.'if-item-list'.item.'physical-if'.'netmask') {
			$NewInterface.IpAddress      += '/' + (ConvertTo-MaskLength $Interface.'if-item-list'.item.'physical-if'.'netmask')
		}
		
		$NewInterface.DefaultGateway  = $Interface.'if-item-list'.item.'physical-if'.'default-gateway'
		
		$NewInterface.Mtu              = $Interface.'if-item-list'.item.'physical-if'.'mtu'
		$NewInterface.AutoNegotiation  = $Interface.'if-item-list'.item.'physical-if'.'auto-negotiation'
		$NewInterface.LinkSpeed        = $Interface.'if-item-list'.item.'physical-if'.'link-speed'
		$NewInterface.MacAddressEnable = $Interface.'if-item-list'.item.'physical-if'.'mac-address-enable'
		$NewInterface.MacAddress       = $Interface.'if-item-list'.item.'physical-if'.'mac-address'
		
		foreach ($Ip in $Interface.'if-item-list'.item.'physical-if'.'secondary-ip-list'.'secondary-ip') {
			$IpEntry = $Ip.ip
			$IpEntry += '/' + (ConvertTo-MaskLength $Ip.netmask)
			$NewInterface.SecondaryIps += $IpEntry
		}
		
		$NewInterface.AntiSpoof         = $Interface.'if-item-list'.item.'physical-if'.'anti-spoof'
		$NewInterface.AntiScan          = $Interface.'if-item-list'.item.'physical-if'.'anti-scan'
		$NewInterface.BlockNotification = $Interface.'if-item-list'.item.'physical-if'.'block-notification'
		$NewInterface.DosPrevention     = $Interface.'if-item-list'.item.'physical-if'.'dos-prevention'
		$NewInterface.IntraInspection   = $Interface.'if-item-list'.item.'physical-if'.'intra-inspection'
				
		$NewInterface.DhcpServerType   = $Interface.'if-item-list'.item.'physical-if'.'dhcp-server'.'server-type'

		$NewInterface.ExternalType = $Interface.'if-item-list'.item.'physical-if'.'external-if'.'external-type'
		$NewInterface.DynamicDns   = $Interface.'if-item-list'.item.'physical-if'.'external-if'.ddns
		
		$NewInterface.VpnDfBit     = $Interface.'if-item-list'.item.'physical-if'.'vpn-df-bit'
		$NewInterface.VpnMinPMtu   = $Interface.'if-item-list'.item.'physical-if'.'vpn-min-pmtu'
		$NewInterface.VpnAgingPMtu = $Interface.'if-item-list'.item.'physical-if'.'vpn-aging-pmtu'
		$NewInterface.IpsecAction  = $Interface.'if-item-list'.item.'ipsec-action'

		$NewInterface.QosMaxBandwidth = $Interface.'if-item-list'.item.'physical-if'.'qos'.'max-link-bandwidth'
		$NewInterface.QosField        = $Interface.'if-item-list'.item.'physical-if'.'qos'.'qos-marking'.'marking-field'
		$NewInterface.QosMethod       = $Interface.'if-item-list'.item.'physical-if'.'qos'.'qos-marking'.'marking-method'.'marking-type'
		$NewInterface.QosPriority     = $Interface.'if-item-list'.item.'physical-if'.'qos'.'qos-marking'.'priority-method'

		$NewInterface.RestrictTraffic    = $Interface.'if-item-list'.item.'physical-if'.'static-mac-ip-binds'.'restrict-traffic'
		$NewInterface.StaticMacAclEnable = $Interface.'if-item-list'.item.'physical-if'.'static-mac-acl'.enable

		$ReturnObject           += $NewInterface		
	}
	
	return $ReturnObject
	
}

###############################################################################
# Get-WgNat

function Get-WgNat {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgNat: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
	
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($Nat in $ConfigContents.profile.'nat-list'.nat) {
		$NewNat                  = New-Object WatchGuardParser.Nat
		$NewNat.Name             = $Nat.Name
		$NewNat.Description      = $Nat.description
		$NewNat.Property         = $Nat.Property
		$NewNat.Type             = $Nat.type
		$NewNat.Algorithm        = $Nat.algorithm
		$NewNat.ProxyArp         = $Nat.'proxy-arp'
		
		if ($Nat.'nat-item'.member) {
			$NewNat.AddressType      = @($Nat.'nat-item'.member)[0].'addr-type'
			$NewNat.Port             = @($Nat.'nat-item'.member)[0].'port'
			$NewNat.ExternalAddress  = @($Nat.'nat-item'.member)[0].'ext-addr-name'
			$NewNat.Interface        = @($Nat.'nat-item'.member)[0].'interface'
			$NewNat.Address          = @($Nat.'nat-item'.member)[0].'addr-name'
		}
		
		$ReturnObject           += $NewNat
		
	}
	
	return $ReturnObject
	
}

###############################################################################
# Get-WgPolicy

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

###############################################################################
# Get-WgService

function Get-WgService {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            NEEDS INFO
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$ConfigContents
	)
	
	$VerbosePrefix = "Get-WgService: "
	
	$IpRx = [regex] "(\d+\.){3}\d+"
		
	$IpProtocols = @{}
	$IpProtocols."6"  = "tcp"
	$IpProtocols."17" = "udp"
	$IpProtocols."0"  = "0"
	$IpProtocols."47" = "GRE"
	$IpProtocols."2"  = "IGMP"
	$IpProtocols."50" = "ESP"
	$IpProtocols."51" = "AH"
	$IpProtocols."89" = "OSPF"
	$IpProtocols."1"  = "ICMP"
			
	$ConfigContents = [xml]$ConfigContents
	$ReturnObject   = @()
	
	foreach ($Service in $ConfigContents.profile.'service-list'.'service') {
		$NewService              = New-Object WatchGuardParser.Service
		$NewService.Name         = $Service.name
		$NewService.Property     = $Service.property
		$NewService.Description  = $Service.description
		$NewService.ProxyType    = $Service.'proxy-type'
		$NewService.IdleTimeout  = $Service.'idle-timeout'
		$ReturnObject           += $NewService
		
		foreach ($Member in $Service.'service-item'.member) {
			$Protocol = $IpProtocols."$($Member.Protocol)"
			if (!($Protocol)) { Write-Verbose "Protocol not found: $($Member.Protocol)" }
			switch ($Member.Type) {
				1 {
					$NewService.Members += "$Protocol/" + $Member.'server-port'
				}
				2 {
					$NewService.Members += $Protocol + '/' + $Member.'start-server-port' + '-' + $Member.'end-server-port'
				}
				default {
					Write-Verbose "$($NewService.Name) member type ($($Member.Type)) not found"
				}
			}
		}
	}
	
	return $ReturnObject
	
}

###############################################################################
# Resolve-WgAlias

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

###############################################################################
# Resolve-WgAuthGroup

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

###############################################################################
# Resolve-WgPolicy

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
                    if ($Lookup) {
                        foreach ($Member in $Lookup.Members) {
                            $NewPolicy                  = HelperCloneCustomType $p ServiceResolved
                            $NewPolicy.ServiceResolved  = $Member
                            $ReturnObject              += $NewPolicy 
                        }
                    } else {
                        Throw "$VerbosePrefix Service not found: $($p.$Field)"
                    }
                }
                Nat {
                    $Lookup                        = $LookupTable | ? { $_.Name -eq $p.$Field }
                    $NewPolicy                     = HelperCloneCustomType $p NatExternalAddress,NatInternalAddress,NatInterface
                    $NewPolicy.NatExternalAddress  = $Lookup.ExternalAddress
                    $NewPolicy.NatInternalAddress  = $Lookup.Address
                    $NewPolicy.NatInterface        = $Lookup.Interface
                    $ReturnObject                 += $NewPolicy
                }
                default { Throw "$VerbosePrefix Field not handled: $Field" }
            }
		} else {
			$ReturnObject += HelperCloneCustomType $p
		}
	}
	
	return $ReturnObject
	
}

###############################################################################
## Start Helper Functions
###############################################################################

###############################################################################
# HelperCloneCustomType

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

###############################################################################
# HelperDetectClassful

function HelperDetectClassful {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True,Position=0,ParameterSetName='RxString')]
		[ValidatePattern("(\d+\.){3}\d+")]
		[String]$IpAddress
	)
	
	$VerbosePrefix = "HelperDetectClassful: "
	
	$Regex = [regex] "(?x)
					  (?<first>\d+)\.
					  (?<second>\d+)\.
					  (?<third>\d+)\.
					  (?<fourth>\d+)"
						  
	$Match = HelperEvalRegex $Regex $IpAddress
	
	$First  = $Match.Groups['first'].Value
	$Second = $Match.Groups['second'].Value
	$Third  = $Match.Groups['third'].Value
	$Fourth = $Match.Groups['fourth'].Value
	
	$Mask = 32
	if ($Fourth -eq "0") {
		$Mask -= 8
		if ($Third -eq "0") {
			$Mask -= 8
			if ($Second -eq "0") {
				$Mask -= 8
			}
		}
	}
	
	return "$IpAddress/$([string]$Mask)"
}

###############################################################################
# HelperEvalRegex

function HelperEvalRegex {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True,Position=0,ParameterSetName='RxString')]
		[String]$RegexString,
		
		[Parameter(Mandatory=$True,Position=0,ParameterSetName='Rx')]
		[regex]$Regex,
		
		[Parameter(Mandatory=$True,Position=1)]
		[string]$StringToEval,
		
		[Parameter(Mandatory=$False)]
		[string]$ReturnGroupName,
		
		[Parameter(Mandatory=$False)]
		[int]$ReturnGroupNumber,
		
		[Parameter(Mandatory=$False)]
		$VariableToUpdate,
		
		[Parameter(Mandatory=$False)]
		[string]$ObjectProperty,
		
		[Parameter(Mandatory=$False)]
		[string]$LoopName
	)
	
	$VerbosePrefix = "HelperEvalRegex: "
	
	if ($RegexString) {
		$Regex = [Regex] $RegexString
	}
	
	if ($ReturnGroupName) { $ReturnGroup = $ReturnGroupName }
	if ($ReturnGroupNumber) { $ReturnGroup = $ReturnGroupNumber }
	
	$Match = $Regex.Match($StringToEval)
	if ($Match.Success) {
		#Write-Verbose "$VerbosePrefix Matched: $($Match.Value)"
		if ($ReturnGroup) {
			#Write-Verbose "$VerbosePrefix ReturnGroup"
			switch ($ReturnGroup.Gettype().Name) {
				"Int32" {
					$ReturnValue = $Match.Groups[$ReturnGroup].Value.Trim()
				}
				"String" {
					$ReturnValue = $Match.Groups["$ReturnGroup"].Value.Trim()
				}
				default { Throw "ReturnGroup type invalid" }
			}
			if ($VariableToUpdate) {
				if ($VariableToUpdate.Value.$ObjectProperty) {
					#Property already set on Variable
					continue $LoopName
				} else {
					$VariableToUpdate.Value.$ObjectProperty = $ReturnValue
					Write-Verbose "$ObjectProperty`: $ReturnValue"
				}
				continue $LoopName
			} else {
				return $ReturnValue
			}
		} else {
			return $Match
		}
	} else {
		if ($ObjectToUpdate) {
			return
			# No Match
		} else {
			return $false
		}
	}
}

###############################################################################
# HelperTestVerbose

function HelperTestVerbose {
[CmdletBinding()]
param()
    [System.Management.Automation.ActionPreference]::SilentlyContinue -ne $VerbosePreference
}

###############################################################################
## Export Cmdlets
###############################################################################

Export-ModuleMember *-*
