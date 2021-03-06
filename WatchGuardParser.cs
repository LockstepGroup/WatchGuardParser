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
	
    public class AuthGroup {
		public string Name;
        public string Description;
        public int Property;
        public int EnableLogin;
        public int AuthGroupType;
        public string MembershipId;
        public string AuthDomain;
        public string AuthGroupName;
    }
    public class EspTransform {
        public int EncryptAlgorithm;
        public int AuthAlgorithm;
        public int TimeUnit;
        public int LifeTime;
        public int LifeLength;
        public int AuthkeyLength;
        public int EncryptKeyLength;
    }
	
    public class IkeAction {
		public string Name;
		public string Description;
		public int Property;
        public int Mode;
        
        public int NatTEnabled;
        public int NatTKeepAlive;
        public int NatTFromPort;
        public int NatTToPort;
        public int NatTUdpChecksumEnabled;
        
        public int Pfs;
        public int Xauth;
        public string RasUserGroup;
        
        public List<IkeTransform> IkeTransforms;
    }
	
    public class IkePolicy {
		public string Name;
		public string Description;
		public int Property;
        public int Enabled;
        
        public string PeerAddress;
        public string IkeAction;
        
        public int KeepAliveInterval;
        public int KeepAliveMax;
        
        public int DpdEnabled;
        public int DpdMaxFailure;
        public int DpdWorryMetric;
        
        public int VpnType;
        public int AutoStart;
        
        public int PeerAuthMask;
        public string PeerAuthIp;
        
        public string RsaCert;
        public int RsaIdType;
        public string DsaCert;
        public int DsaIdType;
        public string Psk;
        public int PskHex;
        
        public int LocalIdType;
        public string LocalIdData;
        public string LocalInterface;
    }
    public class IkePolicyGroup {
        public string Name;
        public string Description;
        public int Property;
        public int Enabled;
        public List<String> IkePolicies;
    }
    public class IkeTransform {
        public string Description;
        public int AuthMethod;
        public int DhGroup;
        public int EncryptAlgorithm;
        public int AuthAlgorithm;
        public int TimeUnit;
        public int LifeTime;
        public int LifeLength;
    }
	
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
	
    public class IpsecAction {
		public string Name;
        public string Description;
        public int Property;
        public int Mode;
        public int KeyMode;
        
        public int UseAnyForService;
        public int UseAnyForAddress;
        public int UseAnyForLocalAddress;
        public int UseAnyForRemoteAddress;
        public int SharingAcrossPolicy;
        
        public int UseLocalRemotePair;
        public List<LocalRemotePair> LocalRemotePairList;
        
        public string IkePolicy;
        public string IkePolicyGroup;
        public int Pfs;
        public int DhGroup;
        
        public List<string> IpsecProposal;
        
        public int Enabled;
    }
	
    public class IpsecProposal {
		public string Name;
        public string Description;
        public int Property;
        public int AntiReplayWindow;
        public int Type;
        
        public List<EspTransform> EspTransforms;
    }
	
    public class LocalRemotePair {
        public string LocalAddress;
        public string RemoteAddress;
        public int Direction;
        public int Nat;
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
	
    public class Policy {
		public string Name;
		public string Description;
		public int Property;
        public string Service;
		public int Firewall;
		public int RejectAction;
		
		public string FromAliasList;
		public string ToAliasList;
		
		public string Proxy;
		public string TrafficMgmt;
		
		public string QosField;
		public string QosMethod;
		public string QosPriority;
		
		public string Nat;
		public string Schedule;
		public string ConnectionRate;
		public string ConnectionRateAlarm;
		
		public int Log;
		public int Enable;
		public int IdleTimeout;
		public int UserFirewall;
		public int IpsMonitorEnabled;
		
		public string Alarm;
		public int SendTcpReset;
		public string PolicyRouting;
		
		public int GlobalStickySetting;
		public int PolicyStickyTimer;
		
		public int Global1To1Nat;
		public int GlobalDnat;
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
