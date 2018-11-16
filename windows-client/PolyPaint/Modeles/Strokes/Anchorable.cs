using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace PolyPaint.Modeles.Strokes
{
    public interface Anchorable
    {
        void showAnchorPoints();
        void hideAnchorPoints();

        bool isOnAnchorPoint(int index, Point point);
        Point getAnchorPointPosition(int index);
    }
}
