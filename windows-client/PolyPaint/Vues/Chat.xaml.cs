using PolyPaint.Modeles;
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

        public Chat()
        {
            InitializeComponent();
            Messages = new ObservableCollection<ChatMessage>();
            Messages.Add(new ChatMessage() {
                Sender = "Jean",
                Timestamp = new DateTime(2018, 9, 22, 14, 30, 45),
                Message = "Bienvenue dans le canal!"
            });
            Messages.Add(new ChatMessage() {
                Sender = "Luc",
                Timestamp = new DateTime(2018, 9, 22, 14, 30, 58),
                Message = "Merci Beaucoup! J'ai hâte de travailler avec vous dans le cadre de ce projet!"
            });

            ChatWindow.ItemsSource = Messages;

            Console.WriteLine("Before");
            var socket = IO.Socket("http://localhost:3000");
            socket.On(Socket.EVENT_CONNECT, (IListener) =>
            {
                socket.Emit("joinRoom", "1", "edit");
            });
            socket.On("message", (IListener) =>
            {
                Console.WriteLine(IListener);
                socket.Emit("chat", "Hello!");
            });
            socket.On("chat", (IListener) =>
            {
                Console.WriteLine("chat: " + IListener);
            });
        }

        private void New_Message(object sender, RoutedEventArgs e)
        {
            Random r = new Random();
            Messages.Add(new ChatMessage()
            {
                Sender = "Bot #" + r.Next(),
                Timestamp = DateTime.Now,
                Message = "EXTERMINATE!"
            });

            ScrollWindow.ScrollToBottom();
        }

        private void Connect_Button(object sender, RoutedEventArgs e)
        {
            LoginDialogBox dlg = new LoginDialogBox();
            if (dlg.ShowDialog() == true)
            {
                Console.WriteLine(dlg.Email + " " + dlg.Password);
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
