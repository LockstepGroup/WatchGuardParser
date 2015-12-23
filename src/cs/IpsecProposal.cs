using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Web;

namespace WatchGuardParser {
	
    public class IpsecProposal {
		public string Name;
        public string Description;
        public int Property;
        public int AntiReplayWindow;
        public int Type;
        
        public List<EspTransform> EspTransforms;
    }
}