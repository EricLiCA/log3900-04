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
using System.Windows.Input;

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
            if (regex.Matches(MessageToSend.Text).Count == 0)
            {
                this.Socket.Emit("message", MessageToSend.Text);
            }

            MessageToSend.Text = "";
            MessageToSend.Focus();
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
                        Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                        Message = (String)server_params[1]
                    });
                    this.ScrollWindow.PageDown();
                });
            }));
            this.Socket.On("setUsernameStatus", new CustomListener((object[] server_params) =>
            {
                if ((String)server_params[0] != "OK")
                {
                    MessageBox.Show((String)server_params[0], "Error connecting", MessageBoxButton.OK, MessageBoxImage.Error);

                    this.Dispatcher.Invoke(() =>
                    {
                        this.Disconnect();
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

        private void TextInput_KeyDown(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (e.Key == Key.Enter && !e.IsRepeat)
            {
                this.Send_Message(sender, e);
            }
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
