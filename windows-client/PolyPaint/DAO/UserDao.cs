using Newtonsoft.Json.Linq;
using PolyPaint.Modeles;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using RestSharp;
using System.Net;
using System.Windows;

namespace PolyPaint.DAO
{
    class UserDao
    {
        public static void Put(User userToUpdate)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.USERS_PATH + "/" + userToUpdate.id, Method.PUT);
            request.AddJsonBody(userToUpdate);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                if (response.StatusCode != HttpStatusCode.OK)
                {
                    MessageBox.Show("Could not update your profile. Username already choosen", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                }
                else
                {
                    dynamic data = JObject.Parse(response.Content);
                    ServerService.instance.user.username = (string)data["username"];
                    ServerService.instance.user.password = (string)data["password"];
                }
            });
        }

        public static void Post(User newUser)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.USERS_PATH, Method.POST);
            request.AddJsonBody(newUser);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                if (response.StatusCode == HttpStatusCode.Created)
                {
                    MessageBox.Show("You can connect to your account using your informations", "Account created !", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                {
                    MessageBox.Show("The username already exists", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            });
        }
    }
}
