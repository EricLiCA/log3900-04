using PolyPaint.Modeles;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using RestSharp;
using System.Net;
using System.Windows;

namespace PolyPaint.DAO
{
    public static class PendingFriendRequestDao
    {
        public static void post(PendingFriendRequest friendRequest)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGE_LIKES_PATH, Method.POST);
            request.AddJsonBody(friendRequest);
            request.AddJsonBody(ServerService.instance.user);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode != HttpStatusCode.Created)
                    {
                        MessageBox.Show("Could not add a like", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });

        }
    }
}
