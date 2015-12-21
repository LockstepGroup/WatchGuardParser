using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Web;

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
        
        public List<string. PolicyList;
    }
}