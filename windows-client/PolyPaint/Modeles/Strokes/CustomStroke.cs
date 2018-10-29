using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles
{
    public abstract class CustomStroke : Stroke
    {
        private bool Selected = false;
        private bool Locked = false;

        public CustomStroke(StylusPointCollection pts) : base(pts)
        {
        }

        public abstract StrokeType getType();

        public abstract bool isSelectable();

        public bool isLocked()
        {
            return this.Locked;
        }

        public bool isSelected()
        {
            if (!isSelectable()) return false;
            return Selected;
        }

        public void Select(StrokeCollection strokes)
        {
            if (!this.Locked && isSelectable())
            {
                this.DrawingAttributes.Color = Colors.Azure;
            }
        }

        public void Unselect(StrokeCollection strokes)
        {
            this.Selected = false;
            this.DrawingAttributes.Color = Colors.Green;
        }

        public void Lock(StrokeCollection strokes)
        {
            if (this.isSelectable())
            {
                this.Locked = true;
                strokes.Remove(this);
                strokes.Add(this);
            }
        }

        public void Unlock(StrokeCollection strokes)
        {
            this.Locked = false;
            strokes.Remove(this);
            strokes.Add(this);
        }
    }

    public enum StrokeType
    {
        OBJECT, RESIZE_GUIDE, ANCHOR_POINT
    }
}
