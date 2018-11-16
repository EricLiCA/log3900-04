using PolyPaint.Modeles;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;

namespace PolyPaint.VueModeles
{
    public class ChatViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        private ChatRoom ChatRoom;

        public ObservableCollection<ChatUser> Users
        {
            get => ChatRoom.Users;
        }

        private ObservableCollection<ChatUser> _availableUsers;
        public ObservableCollection<ChatUser> AvailableUsers
        {
            get
            {
                _availableUsers.Clear();
                UsersManager.instance.Users.Where(user => !ChatRoom.Users.Any(chatUser => chatUser.username == user.username)).ToList().ForEach(user => _availableUsers.Add(new ChatUser(user.username)));
                return _availableUsers;
            }
        }

        public string ThreadName
        {
            get => ChatRoom.Name;
            set { PropertyModified(); }
        }

        public ObservableCollection<ChatMessage> Messages
        {
            get => ChatRoom.Messages;
        }

        public RelayCommand<string> SendMessage { get; set; }
        public RelayCommand<string> AddPerson { get; set; }
        public RelayCommand<string> LeaveRoom { get; set; }

        public ChatViewModel(ChatRoom chatRoom)
        {
            this.ChatRoom = chatRoom;
            ChatRoom.PropertyChanged += new PropertyChangedEventHandler(ChatPropertyChanged);

            SendMessage = new RelayCommand<string>(ChatRoom.SendMessage);
            AddPerson = new RelayCommand<string>(ChatRoom.RequestAddPerson);
            this._availableUsers = new ObservableCollection<ChatUser>();
        }

        protected virtual void PropertyModified([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        private void ChatPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName == "Users")
            {
                this.PropertyModified("Users");
                this.PropertyModified("AvailableUsers");
            }
            else if (e.PropertyName == "Messages")
            {
                this.PropertyModified("Messages");
            }
            else if (e.PropertyName == "ThreadName")
            {
                this.ThreadName = ChatRoom.Name;
            }
        }
    }
}
