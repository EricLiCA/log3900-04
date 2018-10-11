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
