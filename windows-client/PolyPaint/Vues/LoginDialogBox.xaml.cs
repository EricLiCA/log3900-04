using Newtonsoft.Json.Linq;
using PolyPaint.Modeles;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using Quobject.SocketIoClientDotNet.Client;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for LoginDialogBox.xaml
    /// </summary>
    public partial class LoginDialogBox : Window
    {
        public LoginDialogBox()
        {
            InitializeComponent();
            this.ip.Text = Settings.SERVER_IP;
        }

        private void Connect_Click(object sender, RoutedEventArgs e)
        {
            progress.Visibility = Visibility.Visible;
            Verify_Server();
        }

        private void CheckBox_Checked(object sender, RoutedEventArgs e)
        {
            password.IsEnabled = !(bool)anonymous.IsChecked;
        }

        private void Verify_Server()
        {
            var url = string.Format(ip.Text.StartsWith("http") ? "{0}" : "http://{0}", ip.Text);
            var client = new RestClient(url);
            var request = new RestRequest(Settings.API_VERSION + "/status", Method.GET);
            client.ExecuteAsync(request, response =>
            {
                this.Dispatcher.Invoke(() =>
                {
                    if (response.Content == "log3900-server")
                    {
                        ServerService.instance.server = client;
                        Verify_Credentials();
                    }
                    else
                    {
                        progress.Visibility = Visibility.Collapsed;
                        MessageBox.Show("Could not connect to server", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }

        private void Verify_Credentials()
        {
            User user = new User
            {
                username = username.Text,
                password = password.Password
            };
            var request = new RestRequest(Settings.API_VERSION + Settings.SESSION_PATH, Method.POST);
            request.AddJsonBody(user);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                this.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        dynamic data = JObject.Parse(response.Content);
                        ServerService.instance.user = new User
                        {
                            username = username.Text,
                            password = password.Password,
                            id = data["id"],
                            profileImage = data["profileImage"],
                            userLevel = data["userLevel"],
                            token = data["token"]
                    };
                        DialogResult = true;
                    }
                    else
                    {
                        progress.Visibility = Visibility.Collapsed;
                        MessageBox.Show("Wrong Credentials", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }
    }
}
