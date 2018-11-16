﻿using Newtonsoft.Json;
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
        private bool Editing = false;
        protected CustomStrokeCollection strokes;

        public CustomStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts)
        {
            this.strokes = strokes;
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
                strokes.Remove(strokes.get(this.Id.ToString()));
            }
            strokes.Insert(index, this.Clone());

            if (this is Savable)
                Console.WriteLine(((Savable)this).toJson());
        }

        public CustomStroke Duplicate()
        {
            this.stopEditing();
            CustomStroke duplicate = (CustomStroke)this.Clone();
            this.Unselect();
            duplicate.RefreshGuids();
            duplicate.StylusPoints[0] = new StylusPoint(duplicate.StylusPoints[0].X - 10, duplicate.StylusPoints[0].Y - 10);
            duplicate.StylusPoints[1] = new StylusPoint(duplicate.StylusPoints[1].X - 10, duplicate.StylusPoints[1].Y - 10);
            return duplicate;
        }

        public virtual void RefreshGuids() {
            Id = Guid.NewGuid();
        }
    }
}
