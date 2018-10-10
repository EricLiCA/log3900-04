using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Services
{
    class ServerService
    {
        private static ServerService _instance;
        public static ServerService instance
        {
            get
            {
                if (ServerService._instance == null)
                {
                    ServerService._instance = new ServerService();
                }
                return ServerService._instance;
            }
        }

        public ServerService()
        {

        }

        private String ip { get; set; }
        private UInt16 port { get; set; }
        private String email { get; set; }
        private String password { get; set; }
    }
}
