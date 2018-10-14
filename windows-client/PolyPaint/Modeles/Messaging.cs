using PolyPaint.Services;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Windows;

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

        public void NewMessage(ChatRoom room, string sender, string message)
        {
            Console.WriteLine(sender);
            Console.WriteLine(room.Users);
            Application.Current.Dispatcher.Invoke(() => {
                room.Messages.Add(new ChatMessage()
                {
                    Sender = room.Users.First(user => user.Username == sender),
                    Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                    Message = message
                });
            });

            if (this.SubscribedChatRooms.IndexOf(room) != this.selectedIndex)
            {
                if (this.notifications.ContainsKey(room.Name))
                {
                    this.notifications[room.Name] = this.notifications[room.Name] + 1;
                } else
                {
                    this.notifications.Add(room.Name, 1);
                }
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
            room.Users.Add(new User(ServerService.instance.username, "", true));

            ServerService.instance.Socket.Emit("joinRoom", room.Name);
            ServerService.instance.Socket.On("message", new CustomListener((object[] server_params) =>
            {
                if (room.Name != server_params[0].ToString())
                {
                    return;
                }

                this.NewMessage(
                    room,
                    server_params[1].ToString() == "You" ? ServerService.instance.username : server_params[0].ToString(),
                    server_params[2].ToString()
                );
            }));
        }
    }
}
