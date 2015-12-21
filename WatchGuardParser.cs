using System;
using System.Xml;
using System.Web;
using System.Security.Cryptography.X509Certificates;
using System.Net;
using System.Net.Security;
using System.IO;
using System.Collections.Generic;
namespace WatchGuardParser {
	
    public class AddressGroup {
		public string Name;
		public List<string> Members;
		public string Property;
		public string Description;
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
