using PolyPaint.Services;
using PolyPaint.Utilitaires;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Imaging;

namespace PolyPaint.Modeles
{
    public class ChatUser
    {
        private BitmapImage defaultImage = new BitmapImage(new Uri(Settings.DEFAULT_PROFILE_IMAGE));

        public string username { get; set; }
        public BitmapImage profileImage { get; set; }

        public ChatUser(string username)
        {
            this.username = username;

            if (UsersManager.instance.Users.Any(user => user.username == this.username))
            {
                this.profileImage = new BitmapImage(UsersManager.instance.Users.First(user => user.username == this.username).profileImage);
            } else
            {
                this.profileImage = new BitmapImage(new Uri(Settings.DEFAULT_PROFILE_IMAGE));
            }
        }
    }
}
