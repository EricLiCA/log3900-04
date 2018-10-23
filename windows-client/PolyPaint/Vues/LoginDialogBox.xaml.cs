using PolyPaint.Modeles;
using Newtonsoft.Json.Linq;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using Quobject.SocketIoClientDotNet.Client;
using RestSharp;
using System.Net;
using System.Windows;
using PolyPaint.DAO;
using System;

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
            ConnectToServer();
        }

        private void CreateButton_Click(object sender, RoutedEventArgs e)
        {
            CreateButton.IsEnabled = false;
            UserDao.Post(new User { username = UserName.Text, password = Password.Password });
        }

        private void ConnectButton_Click(object sender, RoutedEventArgs e)
        {
            ConnectButton.IsEnabled = false;
            ConnectionProgress.Visibility = Visibility.Visible;
            if ((bool)GuestConnection.IsChecked)
            {
                ServerService.instance.user = new User
                {
                    username = UserName.Text,
                    password = Password.Password,
                    profileImage = new System.Uri(Settings.DEFAULT_PROFILE_IMAGE)
                };
                Connect_Socket();
            } 
            else
            {
                ConnectToAccount();
            }
        }

        private void GuestConnection_Checked(object sender, RoutedEventArgs e)
        {
            Password.IsEnabled = !(bool)GuestConnection.IsChecked;
            CreateButton.IsEnabled = !(bool)GuestConnection.IsChecked;
        }

        private void ConnectToServer()
        {
            var url = string.Format(Settings.SERVER_IP.StartsWith("http") ? "{0}" : "http://{0}", Settings.SERVER_IP);
            var client = new RestClient(url);
            var request = new RestRequest(Settings.API_VERSION + Settings.SERVER_STATUS_PATH, Method.GET);
            client.ExecuteAsync(request, response =>
            {
                this.Dispatcher.Invoke(() =>
                {
                    if (response.Content == "log3900-server")
                    {
                        ServerService.instance.server = client;
                    }
                    else
                    {
                        ConnectButton.IsEnabled = true;
                        ConnectionProgress.Visibility = Visibility.Collapsed;
                        MessageBox.Show("Could not connect to server", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }

        private void ConnectToAccount()
        {
            User user = new User
            {
                username = UserName.Text,
                password = Password.Password,
                profileImage = new System.Uri(Settings.DEFAULT_PROFILE_IMAGE)
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
                        Connect_Socket();

                        ServerService.instance.user = new User(
                            UserName.Text,
                            (string)data["id"],
                            (string)data["profileImage"],
                            (string)data["token"],
                            (string)data["userLevel"],
                            Password.Password
                        );
                    }
                    else
                    {
                        ConnectButton.IsEnabled = true;
                        ConnectionProgress.Visibility = Visibility.Collapsed;
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
                socket.Emit("setUsername", ServerService.instance.user.username);
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
                }
                else
                {
                    this.Dispatcher.Invoke(() =>
                    {
                        ConnectionProgress.Visibility = Visibility.Collapsed;
                        ConnectButton.IsEnabled = true;
                    });
                    socket.Disconnect();
                    MessageBox.Show("Can't connect to the socket : " + server_params[0], "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }));
        }

        private void UserNameOrPassword_KeyUp(object sender, System.Windows.Input.KeyEventArgs e)
        {
            Boolean invalideUserName = UserName.Text.Length == 0 || UserName.Text.Contains(" ");
            Boolean invalidPassword = Password.Password.Length == 0 || Password.Password.Contains(" ");

            if (invalideUserName || invalidPassword)
            {
                CreateButton.IsEnabled = false;
            }
            else
            {
                CreateButton.IsEnabled = true;
            }
        }
    }
}
