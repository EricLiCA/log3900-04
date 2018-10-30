using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles
{
    public abstract class CustomStroke : Stroke
    {
        private bool Selected = false;
        private bool Locked = false;
        private Guid Id = Guid.NewGuid();
        private bool Editing = false;

        public CustomStroke(StylusPointCollection pts) : base(pts)
        {
        }

        public abstract StrokeType getType();
        public abstract new bool HitTest(Point point);
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

        public bool isEditing()
        {
            if (!isSelectable()) return false;
            if (!isLocked()) return false;
            return Editing;
        }

        public void Select(StrokeCollection strokes)
        {
            if (!this.Locked && isSelectable())
            {
                this.Selected = true;
                if (strokes.Any(stroke => ((CustomStroke)stroke).Id == this.Id))
                    strokes.Remove(strokes.First(stroke => ((CustomStroke)stroke).Id == this.Id));
                strokes.Add(this.Clone());
            }
        }

        public void Unselect(StrokeCollection strokes)
        {
            this.Selected = false;
            this.Editing = false;
            if (strokes.Any(stroke => ((CustomStroke)stroke).Id == this.Id))
                strokes.Remove(strokes.First(stroke => ((CustomStroke)stroke).Id == this.Id));
            strokes.Add(this.Clone());
        }

        internal void startEditing(StrokeCollection strokes)
        {
            if (this.Selected)
            {
                this.Editing = true;
                if (strokes.Any(stroke => ((CustomStroke)stroke).Id == this.Id))
                    strokes.Remove(strokes.First(stroke => ((CustomStroke)stroke).Id == this.Id));
                strokes.Add(this.Clone());
            }
        }

        internal void stopEditing(StrokeCollection strokes)
        {
            this.Editing = false;
            if (strokes.Any(stroke => ((CustomStroke)stroke).Id == this.Id))
                strokes.Remove(strokes.First(stroke => ((CustomStroke)stroke).Id == this.Id));
            strokes.Add(this.Clone());
        }

        public void Lock(StrokeCollection strokes)
        {
            if (this.isSelectable())
            {
                this.Locked = true;
                this.Editing = false;
                if (strokes.Any(stroke => ((CustomStroke)stroke).Id == this.Id))
                    strokes.Remove(strokes.First(stroke => ((CustomStroke)stroke).Id == this.Id));
                strokes.Add(this.Clone());
            }
        }

        public void Unlock(StrokeCollection strokes)
        {
            this.Locked = false;
            if (strokes.Any(stroke => ((CustomStroke)stroke).Id == this.Id))
                strokes.Remove(strokes.First(stroke => ((CustomStroke)stroke).Id == this.Id));
            strokes.Add(this.Clone());
        }
    }

    public enum StrokeType
    {
        OBJECT, RESIZE_GUIDE, ANCHOR_POINT
    }
}
