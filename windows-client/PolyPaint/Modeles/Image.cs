using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles
{
    public class Image
    {
        public string id { get; set; }
        public string ownerId { get; set; }
        public string title { get; set; }
        public string protectionLevel { get; set; }
        public string password { get; set; }
        public string thumbnailUrl { get; set; }
        public string fullImageUrl { get; set; }
    }
}
