using PolyPaint.Modeles;
using PolyPaint.Services;
using Quobject.EngineIoClientDotNet.ComponentEmitter;
using Quobject.SocketIoClientDotNet.Client;
using System;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for Chat.xaml
    /// </summary>
    public partial class Chat : Page
    {
        private ObservableCollection<ChatMessage> Messages;
        private Regex regex = new Regex("^ {0,}$");

        public string ThreadName { get; }
        public ObservableCollection<User> Users { get; }

        public Chat(string name, ObservableCollection<User> users)
        {
            this.ThreadName = name;
            this.Users = users;

            InitializeComponent();

            this.Users.Add(new User(ServerService.instance.username, "", true));
            Messages = new ObservableCollection<ChatMessage>();
            ChatWindow.ItemsSource = Messages;

            this.Connect(ServerService.instance.server.BaseUrl.ToString(), ServerService.instance.username);
        }

        private void Send_Message(object sender, RoutedEventArgs e)
        {
            if (regex.Matches(MessageToSend.Text).Count == 0)
            {
                ServerService.instance.Socket.Emit("message", MessageToSend.Text);
            }

            MessageToSend.Text = "";
            MessageToSend.Focus();
        }

        internal void Connect(String url, String username)
        {
            ServerService.instance.Socket.On("message", new CustomListener((object[] server_params) =>
            {
                this.Dispatcher.Invoke(() =>
                {
                    Console.WriteLine(server_params[0].ToString());
                    string sender = server_params[0].ToString() == "You" ? ServerService.instance.username : server_params[0].ToString();
                    Console.WriteLine(sender);
                    Messages.Add(new ChatMessage()
                    {
                        Sender = this.Users.First(user => user.Username == sender),
                        Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                        Message = (String)server_params[1]
                    });
                    this.ScrollWindow.PageDown();
                });
            }));
        }

        internal void Disconnect()
        {
            ServerService.instance.Socket.Disconnect();
            this.Messages.Clear();
        }

        private void TextInput_KeyDown(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (e.Key == Key.Enter && !e.IsRepeat)
            {
                this.Send_Message(sender, e);
            }
        }
    }
}
