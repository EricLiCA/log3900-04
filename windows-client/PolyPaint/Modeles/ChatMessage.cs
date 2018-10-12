using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles
{
    public class ChatMessage
    {
        public User Sender { get; set; }

        public string Timestamp { get; set; }

        public string Message { get; set; }
    }
}
