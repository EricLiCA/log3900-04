using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Ink;
using System.Windows.Input;

namespace PolyPaint.Modeles
{
    public abstract class CustomStroke : Stroke
    {
        public CustomStroke(StylusPointCollection pts) : base(pts)
        {
        }

        public abstract StrokeType getType();
    }

    public enum StrokeType
    {
        OBJECT, RESIZE_GUIDE, ANCHOR_POINT
    }
}
