using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles
{
    public class PendingFriendRequest
    {
        public string id { get; set; }
        public string userName { get; set; }
        public string profileImage { get; set; }
        public Boolean notified { get; set; }
    }
}
