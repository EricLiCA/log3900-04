using PolyPaint.Modeles;
using RestSharp;
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

        public RestClient server { get; set; }
        public User user { get; set; }
        public string token { get; set; }

    }
}
