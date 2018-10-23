using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles
{
    public class PendingFriendRequest
    {
        public string requesterId { get; set; }
        public string receiverId { get; set; }
        public bool notified { get; set; }
    }
}
