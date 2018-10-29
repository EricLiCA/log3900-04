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
        private bool Selected = true;
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

        public void Select()
        {
            if (!this.Locked && isSelectable())
            {
                this.Selected = true;
            }
        }

        public void Unselect()
        {
            this.Selected = false;
        }

        public void Lock()
        {
            if (this.isSelectable())
                this.Locked = true;
        }

        public void Unlock()
        {
            this.Locked = false;
        }
    }

    public enum StrokeType
    {
        OBJECT, RESIZE_GUIDE, ANCHOR_POINT
    }
}
