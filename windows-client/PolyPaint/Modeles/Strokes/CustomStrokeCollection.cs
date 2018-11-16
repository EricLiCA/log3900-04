using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Ink;

namespace PolyPaint.Modeles.Strokes
{
    public class CustomStrokeCollection : StrokeCollection
    {
        public bool has(string id)
        {
            return this.Any(stroke => ((CustomStroke)stroke).Id.ToString() == id);
        }

        public CustomStroke get(string id)
        {
            return (CustomStroke)this.First(stroke => ((CustomStroke)stroke).Id.ToString() == id);
        }
    }
}
