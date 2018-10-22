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
            this.Users.Add(new ChatUser("Caroline"));
            this.Users.Add(new ChatUser("Joshua"));
        }

        public void SendMessage(string message)
        {
            if (regex.Matches(message).Count == 0)
            {
                ServerService.instance.Socket.Emit("message", this.Name, message);
            }
        }

        public void AddPerson(string person)
        {
            this.Users.Add(new ChatUser(person));
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
