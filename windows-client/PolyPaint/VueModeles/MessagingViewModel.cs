using PolyPaint.Modeles;
using PolyPaint.Utilitaires;
using PolyPaint.Vues;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows.Controls;

namespace PolyPaint.VueModeles
{
    class MessagingViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        private Messaging Messaging = new Messaging();

        public ObservableCollection<ChatRoom> NotSubscribedChatRooms
        {
            get => Messaging.NotSubscribedChatRooms;
            set { PropertyModified(); }
        }

        public ObservableCollection<ChatRoom> SubscribedChatRooms
        {
            get => Messaging.SubscribedChatRooms;
            set { PropertyModified(); }
        }

        private List<Chat> chatPages = new List<Chat>();
        public Page ChatWindow
        {
            get
            {
                if (Messaging.SelectedIndex == -1) return null;
                if (Messaging.SelectedIndex == chatPages.Count)
                {
                    ChatViewModel viewModel = new ChatViewModel(SubscribedChatRooms[Messaging.SelectedIndex]);
                    Chat chatPage = new Chat(viewModel);
                    this.chatPages.Add(chatPage);
                    return chatPage;
                }
                return this.chatPages[Messaging.SelectedIndex];
            }
            set { PropertyModified(); }
        }

        public Dictionary<string, int> Notifications
        {
            get => Messaging.Notifications;
            set { PropertyModified(); }
        }

        public RelayCommand<int> OpenChat { get; set; }
        public RelayCommand<string> JoinChat { get; set; }

        public MessagingViewModel()
        {
            Messaging.PropertyChanged += new PropertyChangedEventHandler(MessagingPropertyChanged);

            OpenChat = new RelayCommand<int>(Messaging.OpenChat);
            JoinChat = new RelayCommand<string>(Messaging.JoinChat);
        }

        protected virtual void PropertyModified([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        private void MessagingPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName == "SelectedIndex")
            {
                ChatWindow = null;
            } else if (e.PropertyName == "Notifications")
            {
                this.Notifications = Messaging.Notifications;
            }
            else if (e.PropertyName == "SubscribedChatRooms")
            {
                this.SubscribedChatRooms = Messaging.SubscribedChatRooms;
            }
            else if (e.PropertyName == "NotSubscribedChatRooms")
            {
                this.NotSubscribedChatRooms = Messaging.NotSubscribedChatRooms;
            }
        }
    }
}
