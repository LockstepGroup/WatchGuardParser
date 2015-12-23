using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Web;

namespace WatchGuardParser {
	
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
}