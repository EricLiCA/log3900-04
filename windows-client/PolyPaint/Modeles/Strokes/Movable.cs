using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace PolyPaint.Modeles.Strokes
{
    public interface Movable
    {
        void Move(StylusPointCollection newPoints);
        void DoneMoving();
    }
}
