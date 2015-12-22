using System;
using System.Xml;
using System.Web;
using System.Security.Cryptography.X509Certificates;
using System.Net;
using System.Net.Security;
using System.IO;
using System.Collections.Generic;
namespace WatchGuardParser {
	
    public class AbsPolicy {
		public string Name;
		public string Description;
		public int Property;
        public string Service;
        public bool Enabled;
        
        public string Type;
        public int TrafficType;
        
        public string Firewall;
        public string RejectAction;
        
        public string FromAliasList;
        public string ToAliasList;
        
        public string PolicyNat;
        
        public string Proxy;
        
        public bool Nat1To1;
        public bool ApplyDnatGlobal;
        public bool DNatAllTraffic;
        public string DNatSource;
        
        public string TrafficMgmt;
        public int ConnectionRate;
        public string ConnectionRateAlarm;
        
        public string QosField;
        public string QosMethod;
        public string QosPriority;
        
        public string Schedule;
        public bool AutoBlockenabled;
        public bool LogEnabled;
        public bool SnmpEnabled;
        public bool NotificationEnabled;
        
        public string PolicyRouting;
        public bool IpsMonitorEnabled;
        public int IdleTimeout;
        public int UseGlobalSticky;
        public int StickyTimer;
        
        public List<string> PolicyList;
    }
	
    public class AddressGroup {
		public string Name;
		public List<string> Members;
		public string Property;
		public string Description;
    }
	
    public class Alias {
		public string Name;
		public string Description;
		public string Property;
		
		public List<AliasMember> Members;
    }
	
    public class AliasMember {
		public int Type;
		public string User;
		public string Address;
		public string Interface;
		public string AliasName;
    }
	
    public class Interface {
		public string Name;
		public string Description;
		public int Property;
		public int ItemType;
		
		public int InterfaceNumber;
		public int InterfaceName;
		public int InterfaceProperty;
		public bool Enabled;
		
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
		public int VpnDfBit;
		public string IpsecAction;
		
		public int QosMaxBandwidth
		public int QosField
		public int QosMethod;
		public int QosPriority;
		
		public int RestrictTraffic;
		public int StaticMacAclEnable;
		
    }
	
    public class Nat {
		public string Name;
		public string Description;
		public int Property;
		public int Type;
		public int Algorithm;
		public int ProxyArp;
		public int AddressType;
		public int Port;
		public string ExternalAddress;
		public string Interface;
		public string Address;
    }
	
    public class Service {
		public string Name;
		public string Description;
		public string Property;
		public string ProxyType;
		
		public List<string> Members;
		public int IdleTimeout;
    }
}
