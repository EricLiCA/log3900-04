using PolyPaint.Modeles;
using PolyPaint.Utilitaires;
using PolyPaint.Vues;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Windows.Controls;

namespace PolyPaint.VueModeles
{
    public class MessagingViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        private Messaging Messaging = new Messaging();

        private ObservableCollection<ChatRoom> FilteredNotSubscribedChatRooms;
        public ObservableCollection<ChatRoom> NotSubscribedChatRooms
        {
            get
            {
                FilteredNotSubscribedChatRooms.Clear();
                Messaging.NotSubscribedChatRooms.Where(room => room.Name.Contains(this.filter)).ToList().ForEach(room => FilteredNotSubscribedChatRooms.Add(room));
                return FilteredNotSubscribedChatRooms;
            }
        }

        private ObservableCollection<ChatRoom> FilteredSubscribedChatRooms;
        public ObservableCollection<ChatRoom> SubscribedChatRooms
        {
            get
            {
                FilteredSubscribedChatRooms.Clear();
                Messaging.SubscribedChatRooms.Where(room => room.Name.Contains(this.filter)).ToList().ForEach(room => FilteredSubscribedChatRooms.Add(room));
                return FilteredSubscribedChatRooms;
            }
        }

        private List<Chat> chatPages = new List<Chat>();

        private string filter = "";

        public Page ChatWindow
        {
            get
            {
                if (Messaging.SelectedIndex == -1)
                    return null;

                int index = this.chatPages.FindIndex(Page => Page.ThreadName == Messaging.SubscribedChatRooms[Messaging.SelectedIndex].Name);
                if (index == -1)
                {
                    ChatViewModel viewModel = new ChatViewModel(SubscribedChatRooms[Messaging.SelectedIndex]);
                    viewModel.LeaveRoom = new RelayCommand<string>(Messaging.RequestLeaveChat);
                    Chat chatPage = new Chat(viewModel);
                    this.chatPages.Add(chatPage);
                    return chatPage;
                }
                return this.chatPages[index];
            }
        }

        public Dictionary<string, int> Notifications
        {
            get => Messaging.Notifications;
        }

        public RelayCommand<string> RequestJoinChat { get; set; }
        public RelayCommand<string> NewRoom { get; set; }
        
        public MessagingViewModel()
        {
            Messaging.PropertyChanged += new PropertyChangedEventHandler(MessagingPropertyChanged);

            RequestJoinChat = new RelayCommand<string>(Messaging.RequestJoinChat);
            NewRoom = new RelayCommand<string>(Messaging.NewRoom);
            FilteredNotSubscribedChatRooms = new ObservableCollection<ChatRoom>();
            FilteredSubscribedChatRooms = new ObservableCollection<ChatRoom>();
        }

        public void OpenChat(int index)
        {
            if (index == -1)
            {
                return;
            }

            Messaging.OpenChat(Messaging.SubscribedChatRooms.IndexOf(this.SubscribedChatRooms[index]));
        }

        public void FilterChanged(string filter)
        {
            this.filter = filter;
            PropertyModified("SubscribedChatRooms");
            PropertyModified("NotSubscribedChatRooms");
        }

        protected virtual void PropertyModified([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        private void MessagingPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName == "SelectedIndex")
            {
                PropertyModified("ChatWindow");
            }
            else if (e.PropertyName == "Notifications")
            {
                PropertyModified("Notifications");
            }
            else if (e.PropertyName == "SubscribedChatRooms")
            {
                PropertyModified("SubscribedChatRooms");
            }
            else if (e.PropertyName == "NotSubscribedChatRooms")
            {
                PropertyModified("NotSubscribedChatRooms");
            }
        }
    }
}
