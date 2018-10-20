using Newtonsoft.Json.Linq;
using PolyPaint.Modeles;
using PolyPaint.Utilitaires;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Imaging;

namespace PolyPaint.Services
{
    public class UsersManager
    {
        public List<User> Users { get; set; }

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
            this.Users = new List<User>();
            var request = new RestRequest(Settings.API_VERSION + "/users", Method.GET);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                JArray responseUsers = JArray.Parse(response.Content);
                for (int i = 0; i < responseUsers.Count; i++)
                {
                    dynamic data = JObject.Parse(responseUsers[i].ToString());
                    this.Users.Add(new User((string)data["username"], (string)data["id"], (string)data["profileImage"]));
                }
            });
        } 


    }
}
