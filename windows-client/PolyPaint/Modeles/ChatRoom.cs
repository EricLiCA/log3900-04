using PolyPaint.Vues;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles
{
    class ChatRoom
    {
        public string Name { get; set; }
        public ObservableCollection<User> Users { get; set; }

        private Chat _Page;
        public Chat Page { get
            {
                if (_Page == null)
                {
                    this._Page = new Chat(Name);
                }
                return _Page;
            }}

        public ChatRoom(string name)
        {
            this.Name = name;
            this.Users = new ObservableCollection<User>();
            this.Users.Add(new User("Francis", "anything", true));
            this.Users.Add(new User("Joshua", "anything", false));
            this.Users.Add(new User("Hana", "anything", true));
        }
    }
}
