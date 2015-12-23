using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Web;

namespace WatchGuardParser {
	
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
        public int Pfs;
        public int DhGroup;
        
        public List<string> IpsecProposal;
        
        public int Enabled;
    }
}