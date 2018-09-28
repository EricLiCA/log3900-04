using PolyPaint.Modeles;
using Quobject.EngineIoClientDotNet.ComponentEmitter;
using Quobject.SocketIoClientDotNet.Client;
using System;
using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for Chat.xaml
    /// </summary>
    public partial class Chat : Page
    {
        private ObservableCollection<ChatMessage> Messages;
        private Socket Socket;

        public Chat()
        {
            InitializeComponent();

            Messages = new ObservableCollection<ChatMessage>();
            ChatWindow.ItemsSource = Messages;
            
            Socket = IO.Socket("http://localhost:3000");
            Socket.On(Socket.EVENT_CONNECT, (IListener) =>
            {
                Socket.Emit("joinRoom", "1", "edit");
            });
            Socket.On("message", (data) =>
            {
                Console.WriteLine(data);
            });
            Socket.On("chat", new CustomListener((object[] server_params) =>
            {
                this.Dispatcher.Invoke(() =>
                {
                    Messages.Add(new ChatMessage()
                    {
                        Sender = (String) server_params[0],
                        Timestamp = DateTime.Now,
                        Message = (String)server_params[1]
                    });
                    ScrollWindow.ScrollToBottom();
                });
            }));
        }

        private void Send_Message(object sender, RoutedEventArgs e)
        {
            if (TextInput.Text != "")
            {
                Socket.Emit("chat", TextInput.Text);
                TextInput.Text = "";
            }
        }

        private void Connect_Button(object sender, RoutedEventArgs e)
        {
            LoginDialogBox dlg = new LoginDialogBox();
            if (dlg.ShowDialog() == true)
            {
                Socket.Emit("login", dlg.Email, dlg.Password);
                Socket.On("logged-in", new CustomListener((object[] server_params) =>
                {
                    this.Dispatcher.Invoke(() =>
                    {
                        ConnectButton.Visibility = Visibility.Collapsed;
                    });
                    Console.WriteLine(server_params[0]);
                }));
            };
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
