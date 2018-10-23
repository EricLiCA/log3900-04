﻿using PolyPaint.Services;
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

                if (value == -1) return;
                if (this._notifications.ContainsKey(this.SubscribedChatRooms[value].Name))
                {
                    this._notifications.Remove(this.SubscribedChatRooms[value].Name);
                }
            }
        }

        private Dictionary<string, int> _notifications = new Dictionary<string, int>();
        public Dictionary<string, int> Notifications
        {
            get => this._notifications;
        }

        protected void ProprieteModifiee([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        public Messaging()
        {
            this.NotSubscribedChatRooms = new List<ChatRoom>();
            this.SubscribedChatRooms = new List<ChatRoom>();

            ServerService.instance.Socket.On("joinRoomInfo", new CustomListener((object[] server_params) =>
            {
                ChatRoom room;

                if (this.SubscribedChatRooms.Any(ChatRoom => ChatRoom.Name == (string)server_params[0]))
                {
                    room = this.SubscribedChatRooms.First(ChatRoom => ChatRoom.Name == (string)server_params[0]);
                }
                else if (this.NotSubscribedChatRooms.Any(ChatRoom => ChatRoom.Name == (string)server_params[0]))
                {
                    room = this.NotSubscribedChatRooms.First(ChatRoom => ChatRoom.Name == (string)server_params[0]);
                }
                else
                {
                    room = new ChatRoom((string)server_params[0]);
                    NotSubscribedChatRooms.Add(room);
                }

                if (room.Users.Any(user => user.username == (string)server_params[1])) return;

                if ((string)server_params[1] == ServerService.instance.username)
                {
                    JoinChat(room);
                }

                room.AddPerson(ServerService.instance.username);

                ProprieteModifiee("SubscribedChatRooms");
                ProprieteModifiee("NotSubscribedChatRooms");
            }));

            ServerService.instance.Socket.On("leaveRoomInfo", new CustomListener((object[] server_params) =>
            {
                ChatRoom room;

                if (this.SubscribedChatRooms.Any(ChatRoom => ChatRoom.Name == (string)server_params[0]))
                {
                    room = this.SubscribedChatRooms.First(ChatRoom => ChatRoom.Name == (string)server_params[0]);
                }
                else if (this.NotSubscribedChatRooms.Any(ChatRoom => ChatRoom.Name == (string)server_params[0]))
                {
                    room = this.NotSubscribedChatRooms.First(ChatRoom => ChatRoom.Name == (string)server_params[0]);
                }
                else return;
                
                if ((string)server_params[1] == ServerService.instance.username)
                {
                    LeaveChat(room);
                }

                room.RemovePerson((string)server_params[1]);

                if (room.Users.Count == 0)
                {
                    this.NotSubscribedChatRooms.Remove(room);
                }

                ProprieteModifiee("SubscribedChatRooms");
                ProprieteModifiee("NotSubscribedChatRooms");
            }));

            ServerService.instance.Socket.On("message", new CustomListener((object[] server_params) =>
            {
                if (!this.SubscribedChatRooms.Any(ChatRoom => ChatRoom.Name == (string)server_params[0])) return;

                Application.Current.Dispatcher.Invoke(() => {
                    this.NewMessage(
                        this.SubscribedChatRooms.First(ChatRoom => ChatRoom.Name == (string)server_params[0]),
                        server_params[1].ToString() == "You" ? ServerService.instance.username : server_params[0].ToString(),
                        server_params[2].ToString()
                    );
                });
            }));
        }

        public void NewMessage(ChatRoom room, string sender, string message)
        {
            room.NewMessage(room, sender, message);

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

        internal void OpenChat(int index)
        {
            this.SelectedIndex = index;
        }

        internal void RequestJoinChat(string chatName)
        {
            ServerService.instance.Socket.Emit("joinRoom", chatName);
        }

        internal void NewRoom(string chatName)
        {
            if (this.SubscribedChatRooms.Any(ChatRoom => ChatRoom.Name == chatName))
            {
                this.SelectedIndex = this.SubscribedChatRooms.FindIndex(ChatRoom => ChatRoom.Name == chatName);
            }
            else
            {
                RequestJoinChat(chatName);
            }
        }

        internal void RequestLeaveChat(string chatName)
        {
            ServerService.instance.Socket.Emit("leaveRoom", chatName);
        }

        internal void JoinChat(ChatRoom room)
        {
            this.NotSubscribedChatRooms.Remove(room);
            this.SubscribedChatRooms.Insert(0, room);
            this.OpenChat(this.SubscribedChatRooms.Count - 1);
        }

        internal void LeaveChat(ChatRoom room)
        {
            this.SubscribedChatRooms.Remove(room);
            this.NotSubscribedChatRooms.Insert(0, room);
            this.OpenChat(this.SubscribedChatRooms.Count == 0 ? -1 : 0);
        }
    }
}
