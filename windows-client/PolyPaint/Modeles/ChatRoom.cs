using PolyPaint.Services;
using PolyPaint.Utilitaires;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Media.Imaging;
using System.Windows.Threading;

namespace PolyPaint.Modeles
{
    public class ChatRoom : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        public string Name { get; set; }
        public ObservableCollection<ChatUser> Users { get; }
        public ObservableCollection<ChatMessage> Messages { get; }

        private Regex regex = new Regex("^ {0,}$");

        public ChatRoom(string name)
        {
            this.Name = name;
            this.Users = new ObservableCollection<ChatUser>();
            this.Messages = new ObservableCollection<ChatMessage>();
        }

        public void SendMessage(string message)
        {
            if (regex.Matches(message).Count == 0)
            {
                ServerService.instance.Socket.Emit("message", this.Name, message);
            }
        }

        public void RequestAddPerson(string person)
        {
            ServerService.instance.Socket.Emit("addToRoom", Name, person);
        }

        public void RequestQuit(string person)
        {
            ServerService.instance.Socket.Emit("leaveRoom", Name);
        }

        public void AddPerson(string person)
        {
            if (this.Users.Any(user => user.username == person)) return;

            Application.Current.Dispatcher.Invoke(() => {
                this.Users.Add(new ChatUser(person));
            });

            ProprieteModifiee("Users");
        }

        public void RemovePerson(string person)
        {
            if (!this.Users.Any(user => user.username == person)) return;

            Application.Current.Dispatcher.Invoke(() => {
                this.Users.Remove(this.Users.First(user => user.username == person));
            });

            ProprieteModifiee("Users");
        }

        public void NewMessage(ChatRoom room, string sender, string message)
        {
            bool isAnonymous = !UsersManager.instance.Users.Any(user => user.username == sender);
            Application.Current.Dispatcher.Invoke(() => {
                if (isAnonymous)
                {
                    Messages.Add(new ChatMessage(
                        "Anonymous_" + sender,
                        DateTime.Now.ToString("HH:mm:ss"),
                        message
                    )
                );
                }
                else
                {
                    Messages.Add(new ChatMessage(
                        sender,
                        new BitmapImage(UsersManager.instance.Users.First(user => user.username == sender).profileImage),
                        DateTime.Now.ToString("HH:mm:ss"),
                        message
                    ));
                }
            });

            ProprieteModifiee("Messages");
        }

        protected void ProprieteModifiee([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
