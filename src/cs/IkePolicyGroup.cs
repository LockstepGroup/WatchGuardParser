using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Web;

namespace WatchGuardParser {
    public class IkePolicyGroup {
        public string Name;
        public string Description;
        public int Property;
        public int Enabled;
        public List<String> IkePolicies;
    }
}