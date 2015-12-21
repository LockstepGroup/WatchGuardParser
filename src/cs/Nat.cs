using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Web;

namespace WatchGuardParser {
	
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
}