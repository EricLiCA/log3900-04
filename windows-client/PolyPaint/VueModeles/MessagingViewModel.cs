using PolyPaint.Modeles;
using PolyPaint.Utilitaires;
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

        public Page ChatWindow
        {
            get
            {
                if (Messaging.SelectedIndex == -1) return null;
                return Messaging.SubscribedChatRooms[Messaging.SelectedIndex].Page;
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
                ChatWindow = Messaging.SubscribedChatRooms[Messaging.SelectedIndex].Page;
            } else if (e.PropertyName == "Notifications")
            {
                this.Notifications = Messaging.Notifications;
            }
        }
    }
}
