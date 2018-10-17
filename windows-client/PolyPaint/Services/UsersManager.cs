using PolyPaint.Modeles;
using PolyPaint.Utilitaires;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Services
{
    public class UsersManager
    {
        private static UsersManager _instance;
        public static UsersManager instance
        {
            get
            {
                if (UsersManager._instance == null)
                {
                    UsersManager._instance = new UsersManager();
                }
                return UsersManager._instance;
            }
        }

        public void fetchAll()
        {
            var request = new RestRequest(Settings.API_VERSION + "/users", Method.GET);
            ServerService.instance.server.ExecuteAsync<List<User>>(request, response =>
            {
                Console.WriteLine(response.Content);
            });
        } 


    }

    internal class FetchAllResponse
    {
    }
}
