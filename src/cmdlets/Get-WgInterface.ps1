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

		$ReturnObject           += $NewInterface		
	}
	
	return $ReturnObject
	
}