using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Web;

namespace WatchGuardParser {
    public class EspTransform {
        public int EncryptAlgorithm;
        public int AuthAlgorithm;
        public int TimeUnit;
        public int LifeTime;
        public int LifeLength;
        public int AuthkeyLength;
        public int EncryptKeyLength;
    }
}