using PolyPaint.Modeles.Strokes;
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
        public readonly Guid Id = Guid.NewGuid();
        private bool Editing = false;

        public CustomStroke(StylusPointCollection pts) : base(pts)
        {
        }

        public abstract StrokeType getType();
        public abstract new bool HitTest(Point point);
        public abstract bool isSelectable();
        public abstract void addDragHandles(StrokeCollection strokes);
        public abstract void deleteDragHandles(StrokeCollection strokes);

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
            if (isLocked()) return false;
            return Editing;
        }

        public void Select(CustomStrokeCollection strokes)
        {
            if (!this.Locked && isSelectable())
            {
                this.Selected = true;
                this.Refresh(strokes);
            }
        }

        public void Unselect(CustomStrokeCollection strokes)
        {
            this.Selected = false;
            this.Editing = false;
            this.Refresh(strokes);
        }

        public CustomStroke startEditing(CustomStrokeCollection strokes)
        {
            if (!this.Selected) return null;

            this.Editing = true;
            this.Refresh(strokes);
            return strokes.get(this.Id.ToString());
        }

        public void stopEditing(CustomStrokeCollection strokes)
        {
            this.Editing = false;
            this.Refresh(strokes);
        }

        public void Lock(CustomStrokeCollection strokes)
        {
            if (!this.isSelectable()) return;

            this.Locked = true;
            this.Editing = false;
            this.Refresh(strokes);

        }

        public void Unlock(CustomStrokeCollection strokes)
        {
            this.Locked = false;
            this.Refresh(strokes);
        }

        private void Refresh(CustomStrokeCollection strokes)
        {
            if (strokes.has(this.Id.ToString()))
                strokes.Remove(strokes.get(this.Id.ToString()));
            strokes.Add(this.Clone());
        }
    }

    public enum StrokeType
    {
        OBJECT, RESIZE_GUIDE, ANCHOR_POINT
    }
}
