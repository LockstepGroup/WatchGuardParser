using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Web;

namespace WatchGuardParser {
	
    public class Interface {
		public string Name;
		public string Description;
		public int Property;
		public int ItemType;
		
		public int InterfaceNumber;
		public string InterfaceName;
		public int InterfaceProperty;
		public int Enabled;
		
		public string IpType;
		public string IpAddress;
		public string DefaultGateway;
		
		public int Mtu;
		public int AutoNegotiation;
		public int LinkSpeed;
		public int MacAddressEnable;
		public string MacAddress;
		
		public List<string> SecondaryIps;
		
		public int AntiSpoof;
		public int AntiScan;
		public int BlockNotification;
		public int DosPrevention;
		public int IntraInspection;
		
		public int DhcpServerType;
		
		public int ExternalType;
		public int DynamicDns;
		
		public int VpnDfBit;
		public int VpnMinPMtu;
		public int VpnAgingPMtu;
		public string IpsecAction;
		
		public int QosMaxBandwidth;
		public int QosField;
		public int QosMethod;
		public int QosPriority;
		
		public int RestrictTraffic;
		public int StaticMacAclEnable;
		
    }
}