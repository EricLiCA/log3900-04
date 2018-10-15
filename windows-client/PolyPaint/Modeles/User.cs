using System.Windows.Media.Imaging;

namespace PolyPaint.Modeles
{
    public class User
    {
        public string Username { get; set; }
        public BitmapImage ProfileImage { get; set; }
        public bool Friend;

        public User(string name, string profileImageUrl, bool friend)
        {
            this.Username = name;
            this.Friend = friend;
            this.ProfileImage = new BitmapImage(new System.Uri("https://mts.intechopen.com/storage/users/528/images/system/528.jpg"));
        }
    }
}