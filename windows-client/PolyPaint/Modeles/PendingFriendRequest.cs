using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles
{
    class PendingFriendRequest
    {
        public string requesterId { get; set; }
        public string receiverId { get; set; }
        public Boolean notified { get; set; }
    }
}
