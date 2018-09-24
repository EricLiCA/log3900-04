using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles
{
    class ChatMessage
    {
        public string Sender { get; set; }

        public DateTime Timestamp { get; set; }

        public string Message { get; set; }
    }
}
