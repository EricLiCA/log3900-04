using PolyPaint.Services;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;

namespace PolyPaint.Modeles
{
    public class Messaging : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        public ObservableCollection<ChatRoom> NotSubscribedChatRooms { get; }
        public ObservableCollection<ChatRoom> SubscribedChatRooms { get; }

        private int selectedIndex = -1;
        public int SelectedIndex
        {
            get => this.selectedIndex;
            private set
            {
                selectedIndex = value;
                ProprieteModifiee();
            }
        }

        private Dictionary<string, int> notifications = new Dictionary<string, int>();
        public Dictionary<string, int> Notifications
        {
            get => this.notifications;
        }

        public void newMessage(string room, string from, string message, string timestamp)
        {
            ChatRoom destinationRoom = this.SubscribedChatRooms.First<ChatRoom>(r => room == r.Name);
            if (this.SubscribedChatRooms.IndexOf(destinationRoom) != selectedIndex)
            {
                int previousAmount = this.notifications.ContainsKey(room) ? this.notifications[room] : 0;
                this.notifications.Add(room, previousAmount + 1);
                ProprieteModifiee("Notifications");
            }
        }

        protected void ProprieteModifiee([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        public Messaging()
        {
            this.NotSubscribedChatRooms = new ObservableCollection<ChatRoom>();
            this.SubscribedChatRooms = new ObservableCollection<ChatRoom>();

            this.NotSubscribedChatRooms.Add(new ChatRoom("Fun Times"));
            this.NotSubscribedChatRooms.Add(new ChatRoom("Happy Meal"));
            this.NotSubscribedChatRooms.Add(new ChatRoom("Feelin' Good"));
        }

        internal void OpenChat(int index)
        {
            this.SelectedIndex = index;
        }

        internal void JoinChat(string chatName)
        {
            ChatRoom room = this.NotSubscribedChatRooms.First<ChatRoom>(ChatRoom => ChatRoom.Name == chatName);
            this.NotSubscribedChatRooms.Remove(room);
            this.SubscribedChatRooms.Add(room);
            this.OpenChat(this.SubscribedChatRooms.Count - 1);
            room.Register();
            room.Users.Add(new User(ServerService.instance.username, "", true));
        }
    }
}
