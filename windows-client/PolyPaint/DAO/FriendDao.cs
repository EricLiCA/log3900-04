using PolyPaint.Modeles;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace PolyPaint.DAO
{
    public static class FriendDao
    {
        public static void Delete(Friend friend)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.FRIENDS_PATH + "/" + ServerService.instance.user.id, Method.DELETE);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode != HttpStatusCode.OK)
                    {
                        MessageBox.Show("Could not delete this friend", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }

        public static void GetAll()
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.FRIENDS_PATH, Method.GET);
            ServerService.instance.server.ExecuteAsync<Image>(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    /*Users currentUsers = ((MainWindow)Application.Current.MainWindow).Users;
                    currentUsers.LoadUsers(response);*/
                });
            });
        }
    }


}
