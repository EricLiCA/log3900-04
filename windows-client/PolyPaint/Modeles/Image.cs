using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles
{
    public class Image
    {
        public string Id { get; set; }
        public string OwnerId { get; set; }
        public string Title { get; set; }
        public string ProtectionLevel { get; set; }
        public string Password { get; set; }
        public string ThumbnailUrl { get; set; }
        public string FullImageUrl { get; set; }
    }
}
