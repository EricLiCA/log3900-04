using PolyPaint.Modeles;
using PolyPaint.Utilitaires;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace PolyPaint.VueModeles
{
    public class ChatViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        private ChatRoom ChatRoom;

        public ObservableCollection<User> Users
        {
            get => ChatRoom.Users;
            set { PropertyModified(); }
        }

        public string ThreadName
        {
            get => ChatRoom.Name;
            set { PropertyModified(); }
        }

        public ObservableCollection<ChatMessage> Messages
        {
            get => ChatRoom.Messages;
            set { PropertyModified(); }
        }

        public RelayCommand<string> SendMessage { get; set; }
        public RelayCommand<string> AddPerson { get; set; }
        public RelayCommand<string> LeaveRoom { get; set; }

        public ChatViewModel(ChatRoom chatRoom)
        {
            this.ChatRoom = chatRoom;
            ChatRoom.PropertyChanged += new PropertyChangedEventHandler(ChatPropertyChanged);

            SendMessage = new RelayCommand<string>(ChatRoom.SendMessage);
            AddPerson = new RelayCommand<string>(ChatRoom.AddPerson);
        }

        protected virtual void PropertyModified([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        private void ChatPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName == "Users")
            {
                this.Users = ChatRoom.Users;
            }
            else if (e.PropertyName == "Messages")
            {
                this.Messages = ChatRoom.Messages;
            }
            else if (e.PropertyName == "ThreadName")
            {
                this.ThreadName = ChatRoom.Name;
            }
        }
    }
}
