using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles.Strokes
{
    interface Savable
    {
        string toJson();
        StrokeType StrokeType();
    }

    public enum StrokeType
    {
        ELLIPSE, TRIANGLE, RECTANGLE, USE, LINE, CLASS, ACTOR
    }
}
