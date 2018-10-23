using PolyPaint.Services;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Media.Imaging;

namespace PolyPaint.Modeles
{
    public class Messaging : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        
        public List<ChatRoom> NotSubscribedChatRooms { get; }
        public List<ChatRoom> SubscribedChatRooms { get; }

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

        private Dictionary<string, int> _notifications = new Dictionary<string, int>();
        public Dictionary<string, int> Notifications
        {
            get => this._notifications;
        }

        public void NewMessage(ChatRoom room, string sender, string message)
        {
            bool isAnonymous = !UsersManager.instance.Users.Any(user => user.username == sender);
            Application.Current.Dispatcher.Invoke(() => {
                if (isAnonymous)
                {
                    room.Messages.Add(new ChatMessage(
                        "Anonymous_" + sender,
                        DateTime.Now.ToString("HH:mm:ss"),
                        message
                    )
                );
                } else
                {
                    room.Messages.Add(new ChatMessage(
                        sender,
                        new BitmapImage(UsersManager.instance.Users.First(user => user.username == sender).profileImage),
                        DateTime.Now.ToString("HH:mm:ss"),
                        message
                    ));
                }
            });

            if (this.SubscribedChatRooms.IndexOf(room) != this.selectedIndex)
            {
                if (this._notifications.ContainsKey(room.Name))
                {
                    this._notifications[room.Name] = this._notifications[room.Name] + 1;
                } else
                {
                    this._notifications.Add(room.Name, 1);
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
            this.NotSubscribedChatRooms = new List<ChatRoom>();
            this.SubscribedChatRooms = new List<ChatRoom>();

            this.NotSubscribedChatRooms.Add(new ChatRoom("Fun Times"));
            this.NotSubscribedChatRooms.Add(new ChatRoom("Happy Meal"));
            this.NotSubscribedChatRooms.Add(new ChatRoom("Feelin' Good"));

            ServerService.instance.Socket.On("joinRoomInfo", new CustomListener((object[] server_params) =>
            {
                if ((string)server_params[1] == ServerService.instance.username)
                {
                    JoinChat((string)server_params[0]);
                }

                if (this.SubscribedChatRooms.Any(ChatRoom => ChatRoom.Name == (string)server_params[0]))
                {
                    this.SubscribedChatRooms.First<ChatRoom>(ChatRoom => ChatRoom.Name == (string)server_params[0]).AddPerson((string)server_params[1]);
                }
                else if (this.NotSubscribedChatRooms.Any(ChatRoom => ChatRoom.Name == (string)server_params[0]))
                {
                    this.NotSubscribedChatRooms.First<ChatRoom>(ChatRoom => ChatRoom.Name == (string)server_params[0]).AddPerson((string)server_params[1]);
                }

                string userName = (string)server_params[1];
            }));

            ServerService.instance.Socket.On("leaveRoomInfo", new CustomListener((object[] server_params) =>
            {

            }));
        }

        internal void OpenChat(int index)
        {
            this.SelectedIndex = index;
        }

        internal void RequestJoinChat(string chatName)
        {
            ServerService.instance.Socket.Emit("joinRoom", chatName);
        }

        internal void JoinChat(string chatName)
        {
            ChatRoom room = this.NotSubscribedChatRooms.First<ChatRoom>(ChatRoom => ChatRoom.Name == chatName);
            this.NotSubscribedChatRooms.Remove(room);
            this.SubscribedChatRooms.Add(room);
            this.OpenChat(this.SubscribedChatRooms.Count - 1);
            room.AddPerson(ServerService.instance.username);

            ProprieteModifiee("SubscribedChatRooms");
            ProprieteModifiee("NotSubscribedChatRooms");
            
            if (room.ConnectionStatus == ConnectionStatus.NOT_CONNECTED)
            {
                ServerService.instance.Socket.On("message", new CustomListener((object[] server_params) =>
                {
                    if (room.Name != server_params[0].ToString() || room.ConnectionStatus != ConnectionStatus.JOINED)
                    {
                        return;
                    }

                    Application.Current.Dispatcher.Invoke(() => { 
                        this.NewMessage(
                            room,
                            server_params[1].ToString() == "You" ? ServerService.instance.username : server_params[0].ToString(),
                            server_params[2].ToString()
                        );
                    });
                }));
            }

            room.ConnectionStatus = ConnectionStatus.JOINED;
        }

        internal void LeaveChat(string chatName)
        {
            ChatRoom room = this.SubscribedChatRooms.First<ChatRoom>(ChatRoom => ChatRoom.Name == chatName);
            this.SubscribedChatRooms.Remove(room);
            this.NotSubscribedChatRooms.Add(room);
            this.OpenChat(this.SubscribedChatRooms.Count == 0 ? -1 : 0);
            room.RemovePerson(ServerService.instance.username);
            room.ConnectionStatus = ConnectionStatus.LEFT;
            ServerService.instance.Socket.Emit("leaveRoom", room.Name);
            ProprieteModifiee("SubscribedChatRooms");
            ProprieteModifiee("NotSubscribedChatRooms");
        }
    }
}
