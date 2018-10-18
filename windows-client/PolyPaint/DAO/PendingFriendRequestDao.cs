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
        public static void Send(PendingFriendRequest friendRequest)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.PENDING_FRIEND_REQUEST_PATH + "/" 
                + ServerService.instance.user.id, Method.POST);
            request.AddJsonBody(friendRequest);
            request.AddJsonBody(ServerService.instance.user);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode != HttpStatusCode.Created)
                    {
                        MessageBox.Show("Could not send a friend request to this user", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }

        public static void Accept(PendingFriendRequest friendRequest)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.PENDING_FRIEND_REQUEST_PATH + "/"
                + ServerService.instance.user.id, Method.POST);
            request.AddJsonBody(friendRequest);
            request.AddJsonBody(ServerService.instance.user);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode != HttpStatusCode.Created)
                    {
                        MessageBox.Show("Could not accept this friend request", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }

        public static void Refuse(PendingFriendRequest friendRequest)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.PENDING_FRIEND_REQUEST_PATH + "/"
                + ServerService.instance.user.id, Method.DELETE);
            request.AddJsonBody(friendRequest);
            request.AddJsonBody(ServerService.instance.user);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode != HttpStatusCode.OK)
                    {
                        MessageBox.Show("Could not refuse this friend request", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }
    }
}
