using PolyPaint.Services;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Threading;

namespace PolyPaint.Modeles
{
    public class ChatRoom : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        public string Name { get; set; }
        public ObservableCollection<User> Users { get; }
        public ObservableCollection<ChatMessage> Messages { get; }

        private Regex regex = new Regex("^ {0,}$");

        public ChatRoom(string name)
        {
            this.Name = name;
            this.Users = new ObservableCollection<User>();
            this.Messages = new ObservableCollection<ChatMessage>();
            this.Users.Add(new User("Francis", "anything", true));
            this.Users.Add(new User("Joshua", "anything", false));
            this.Users.Add(new User("Hana", "anything", true));
        }

        public void Register()
        {
            ServerService.instance.Socket.On("message", new CustomListener((object[] server_params) =>
            {
                string sender = server_params[0].ToString() == "You" ? ServerService.instance.username : server_params[0].ToString();
                Application.Current.Dispatcher.Invoke(() => {
                    Messages.Add(new ChatMessage()
                    {
                        Sender = this.Users.First(user => user.Username == sender),
                        Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                        Message = (string)server_params[1]
                    });
                });
            }));
        }

        public void SendMessage(string message)
        {
            if (regex.Matches(message).Count == 0)
            {
                ServerService.instance.Socket.Emit("message", message);
            }
        }

        protected void ProprieteModifiee([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
