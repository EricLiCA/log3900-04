using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles
{
    public class ImageComment
    {
        public string imageId { get; set; }
        public string userId { get; set; }
        public DateTime timestamp { get; set; }
        public string comment { get; set; }
    }
}
