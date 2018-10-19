﻿using PolyPaint.Modeles;
using Newtonsoft.Json.Linq;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using Quobject.SocketIoClientDotNet.Client;
using RestSharp;
using System.Net;
using System.Windows;
using System.Windows.Media.Imaging;

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
            connect.IsEnabled = false;
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
                        connect.IsEnabled = true;
                        progress.Visibility = Visibility.Collapsed;
                        MessageBox.Show("Could not connect to server", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }

        private void Verify_Credentials()
        {
            User user = new User {
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
                        ServerService.instance.id = data["id"];
                        ServerService.instance.token = data["token"];
                        ServerService.instance.username = username.Text;
                        Connect_Socket();
                        
                        ServerService.instance.user = new User(
                            username.Text,
                            (string)data["id"],
                            (string)data["profileImage"],
                            (string)data["token"],
                            (string)data["userLevel"],
                            password.Password
						);
                    }
                    else
                    {
                        connect.IsEnabled = true;
                        progress.Visibility = Visibility.Collapsed;
                        MessageBox.Show("Wrong Credentials", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }

        private void Connect_Socket()
        {
            Socket socket = IO.Socket(ServerService.instance.server.BaseUrl);
            socket.On(Socket.EVENT_CONNECT, (IListener) =>
            {
                socket.Emit("setUsername", ServerService.instance.username);
                socket.Off(Socket.EVENT_CONNECT);
            });

            socket.On("setUsernameStatus", new CustomListener((object[] server_params) =>
            {
                if ((string)server_params[0] == "OK")
                {
                    ServerService.instance.Socket = socket;

                    this.Dispatcher.Invoke(() =>
                    {
                        DialogResult = true;
                    });
                } else
                {
                    this.Dispatcher.Invoke(() =>
                    {
                        progress.Visibility = Visibility.Collapsed;
                        connect.IsEnabled = true;
                    });
                    socket.Disconnect();
                    MessageBox.Show("Can't connect to the socket : " + server_params[0], "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }));
        }

        private class Credentials
        {
            public string username;
            public string password;

            public Credentials(string username, string password)
            {
                this.username = username;
                this.password = password;
            }
        }

        private class LoginResponse
        {
            public string id { get; }
            public string token { get; }
        }
    }
}
