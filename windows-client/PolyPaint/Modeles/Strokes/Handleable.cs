using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace PolyPaint.Modeles.Strokes
{
    public interface Handleable
    {
        void addDragHandles();
        void deleteDragHandles();
        void handleMoved(Guid id, Point point);
    }
}
