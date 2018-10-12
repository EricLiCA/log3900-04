using PolyPaint.Modeles;
using PolyPaint.Services;
using Quobject.EngineIoClientDotNet.ComponentEmitter;
using Quobject.SocketIoClientDotNet.Client;
using System;
using System.Collections.ObjectModel;
using System.IO;
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

        public string ThreadName { get; set; }

        public Chat(string name)
        {
            this.ThreadName = name;

            InitializeComponent();
            
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
                    Messages.Add(new ChatMessage()
                    {
                        Sender = (String)server_params[0],
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
