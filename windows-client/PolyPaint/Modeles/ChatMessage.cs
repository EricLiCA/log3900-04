using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Imaging;

namespace PolyPaint.Modeles
{
    public class ChatMessage
    {
        public string Sender { get; set; }

        public BitmapImage ProfileImage { get; set; }

        public string Timestamp { get; set; }

        public string Message { get; set; }

        public ChatMessage(string Sender, BitmapImage ProfileImage, string Timestamp, string Message)
        {
            this.Sender = Sender;
            this.ProfileImage = ProfileImage;
            this.Timestamp = Timestamp;
            this.Message = Message;
        }

        public ChatMessage(string Sender, string Timestamp, string Message)
        {
            this.Sender = Sender;
            this.ProfileImage = new BitmapImage(new Uri("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjqmTWoUhezVh6rd7F0DYqkpqDGAwbYoC_hEfi0nphYL1h08gCkA"));
            
            this.Timestamp = Timestamp;
            this.Message = Message;
        }
    }
}
