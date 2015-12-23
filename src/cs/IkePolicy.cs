using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Web;

namespace WatchGuardParser {
	
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
}