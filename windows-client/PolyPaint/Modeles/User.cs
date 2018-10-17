using System.Windows.Media.Imaging;

namespace PolyPaint.Modeles
{
    public class User
    {
        private string id { get; set; }
        public string username { get; set; }
        public BitmapImage profileImage { get; set; }

        public User(string id, string username, string profileImageUrl)
        {
            this.id = id;
            this.username = username;
            this.profileImage = new BitmapImage(new System.Uri("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjqmTWoUhezVh6rd7F0DYqkpqDGAwbYoC_hEfi0nphYL1h08gCkA"));
        }
    }
}