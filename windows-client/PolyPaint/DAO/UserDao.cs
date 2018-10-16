using RestSharp;
using PolyPaint.Utilitaires;
using PolyPaint.Services;
using System.Windows;
using PolyPaint.Vues;
using PolyPaint.Modeles;

namespace PolyPaint.DAO
{
    class UserDao
    {
        public static void GetAll()
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.USERS_PATH, Method.GET);
            ServerService.instance.server.ExecuteAsync<User>(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    Users currentUsers = ((MainWindow)Application.Current.MainWindow).Users;
                    currentUsers.LoadUsers(response);
                });
            });
        }
    }
}
