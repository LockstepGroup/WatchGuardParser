using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Web;

namespace WatchGuardParser {
	
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
}