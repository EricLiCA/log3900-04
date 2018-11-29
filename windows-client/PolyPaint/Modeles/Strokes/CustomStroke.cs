using Newtonsoft.Json;
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
        public Guid Id = Guid.NewGuid();
        public int Index;
        private bool Editing = false;
        protected CustomStrokeCollection strokes;

        public CustomStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts)
        {
            this.strokes = strokes;
            Id = Guid.NewGuid();
            this.Index = strokes.Count > 0 ? ((CustomStroke)strokes.Last()).Index + 1 : 1;
        }

        public CustomStroke(int index, StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts)
        {
            this.strokes = strokes;
            Id = Guid.NewGuid();
            this.Index = index;
        }

        public CustomStroke(string id, int index, StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts)
        {
            this.strokes = strokes;
            Id = new Guid(id);
            this.Index = index;
        }

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
            if (isLocked()) return false;
            return Editing;
        }

        public void Select()
        {
            if (!this.Locked && isSelectable())
            {
                this.Selected = true;
                this.Refresh();
            }
        }

        public void Unselect()
        {
            this.Selected = false;
            this.Editing = false;
            this.Refresh();
        }

        public CustomStroke startEditing()
        {
            if (!this.Selected) return null;
            
            this.Editing = true;
            this.Refresh();
            return strokes.get(this.Id.ToString());
        }

        public void stopEditing()
        {
            this.Editing = false;
            this.Refresh();
        }

        public void Lock()
        {
            if (!this.isSelectable()) return;

            this.Locked = true;
            this.Editing = false;
            this.Refresh();

        }


        public void Unlock()
        {
            this.Locked = false;
            this.Refresh();
        }

        public virtual void Refresh()
        {
            int index = -1;
            if (strokes.has(this.Id.ToString()))
            {
                if (this is Handleable)
                    ((Handleable)strokes.get(this.Id.ToString())).deleteDragHandles();

                index = strokes.IndexOf(strokes.get(this.Id.ToString()));
                if (strokes.has(this.Id.ToString()))
                    strokes.Remove(strokes.get(this.Id.ToString()));
            }
            strokes.Insert(index, this.Clone());
        }

        public CustomStroke Duplicate()
        {
            this.strokes.get(this.Id.ToString()).stopEditing();
            this.strokes.get(this.Id.ToString()).Unselect();
            CustomStroke duplicate = (CustomStroke)this.Clone();
            duplicate.RefreshGuids();
            for (int i = 0; i < duplicate.StylusPoints.Count; i++)
            {
                duplicate.StylusPoints[i] = new StylusPoint(duplicate.StylusPoints[i].X - 10, duplicate.StylusPoints[i].Y - 10);
            }
            return duplicate;
        }

        public virtual void RefreshGuids() {
            Id = Guid.NewGuid();
        }
    }
}
