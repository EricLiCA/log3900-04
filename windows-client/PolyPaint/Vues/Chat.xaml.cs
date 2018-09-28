using PolyPaint.Modeles;
using Quobject.EngineIoClientDotNet.ComponentEmitter;
using Quobject.SocketIoClientDotNet.Client;
using System;
using System.Collections.ObjectModel;
using System.IO;
using System.Net;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for Chat.xaml
    /// </summary>
    public partial class Chat : Page
    {
        private FenetreDessin MainWindow;
        private ObservableCollection<ChatMessage> Messages;
        private Socket Socket;
        private Regex regex = new Regex("^ {0,}$");

        public Chat(FenetreDessin mainWindow, String url, String username)
        {
            InitializeComponent();

            this.MainWindow = mainWindow;
            Messages = new ObservableCollection<ChatMessage>();
            ChatWindow.ItemsSource = Messages;

            this.Connect(url, username);
        }

        private void Send_Message(object sender, RoutedEventArgs e)
        {
            if (regex.Matches(TextInput.Text).Count == 0)
            {
                this.Socket.Emit("message", TextInput.Text);
            }

            TextInput.Text = "";
        }

        internal void Connect(String url, String username)
        {
            this.Socket = IO.Socket(url);
            this.Socket.On(Socket.EVENT_CONNECT, (IListener) =>
            {
                Socket.Emit("setUsername", username);
            });
            this.Socket.On("message", new CustomListener((object[] server_params) =>
            {
                this.Dispatcher.Invoke(() =>
                {
                    Messages.Add(new ChatMessage()
                    {
                        Sender = (String)server_params[0],
                        Timestamp = DateTime.Now,
                        Message = (String)server_params[1]
                    });
                });
            }));
            this.Socket.On("setUsernameStatus", new CustomListener((object[] server_params) =>
            {
                if ((String)server_params[0] != "OK")
                {
                    this.Disconnect();
                    MessageBox.Show((String)server_params[0], "Error connecting", MessageBoxButton.OK, MessageBoxImage.Error);

                    this.Dispatcher.Invoke(() =>
                    {
                        MainWindow.Menu_Disconnect_Click(this, null);
                    });
                }
            }));
        }

        internal void Disconnect()
        {
            this.Socket.Disconnect();
            this.Messages.Clear();
        }
    }

    public class CustomListener : IListener
    {
        private static int id_counter = 0;
        private int Id;
        private readonly Action<object[]> fn;

        public CustomListener(Action<object[]> fn)
        {

            this.fn = fn;
            this.Id = id_counter++;
        }



        public void Call(params object[] args)
        {
            fn(args);
        }


        public int CompareTo(IListener other)
        {
            return this.GetId().CompareTo(other.GetId());
        }

        public int GetId()
        {
            return Id;
        }
    }
}
