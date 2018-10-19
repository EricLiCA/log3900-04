using PolyPaint.Modeles;
using PolyPaint.Utilitaires;
using PolyPaint.Vues;
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
                if (Messaging.SelectedIndex == -1)
                    return null;

                int index = this.chatPages.FindIndex(Page => Page.ThreadName == Messaging.SubscribedChatRooms[Messaging.SelectedIndex].Name);
                if (index == -1)
                {
                    ChatViewModel viewModel = new ChatViewModel(SubscribedChatRooms[Messaging.SelectedIndex]);
                    viewModel.LeaveRoom = new RelayCommand<string>(Messaging.LeaveChat);
                    Chat chatPage = new Chat(viewModel);
                    this.chatPages.Add(chatPage);
                    return chatPage;
                }
                return this.chatPages[index];
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
                this.ChatWindow = null;
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
