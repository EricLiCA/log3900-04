using RestSharp;
using PolyPaint.Utilitaires;
using PolyPaint.Services;
using System.Windows;
using PolyPaint.Vues;
using PolyPaint.Modeles;
using System.Net;

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
                    MessageBox.Show("Could not update your profile", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            });
        }
    }
}
