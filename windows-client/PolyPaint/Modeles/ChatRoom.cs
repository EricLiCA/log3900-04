using PolyPaint.Services;
using PolyPaint.Utilitaires;
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
        public ObservableCollection<ChatUser> Users { get; }
        public ObservableCollection<ChatMessage> Messages { get; }
        public ConnectionStatus ConnectionStatus = ConnectionStatus.NOT_CONNECTED;

        private Regex regex = new Regex("^ {0,}$");

        public ChatRoom(string name)
        {
            this.Name = name;
            this.Users = new ObservableCollection<ChatUser>();
            this.Messages = new ObservableCollection<ChatMessage>();
            Random r = new Random(DateTime.Now.Millisecond + Name.ToCharArray()[0] + Name.ToCharArray()[1]);
            for (var i = 0; i <= r.Next() % 12; i++)
            {
                var n = UsersManager.instance.Users[r.Next(0, UsersManager.instance.Users.Count)].username;
                if (this.Users.Any(u => u.username == n) || n == ServerService.instance.username) continue;
                this.Users.Add(new ChatUser(n));
            }
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

        protected void ProprieteModifiee([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }

    public enum ConnectionStatus
    {
        NOT_CONNECTED, JOINED, LEFT 
    }
}
