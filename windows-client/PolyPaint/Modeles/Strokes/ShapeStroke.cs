using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;

namespace PolyPaint.Modeles.Strokes
{
     public abstract class ShapeStroke : CustomStroke
    {
        DragHandle TOP_LEFT;
        DragHandle BOTTOM_LEFT;
        DragHandle TOP_RIGHT;
        DragHandle BOTTOM_RIGHT;

        AnchorPoint TOP;
        AnchorPoint BOTTOM;
        AnchorPoint LEFT;
        AnchorPoint RIGHT;

        protected bool AnchorPointVisibility = false;

        public ShapeStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {

        }

        public override void addDragHandles()
        {
            if (!this.strokes.has(this.Id.ToString())) return;

            int index = this.strokes.IndexOf(this.strokes.get(Id.ToString())) + 1;
            if (TOP_LEFT == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X) - 4, Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y) - 4));
                TOP_LEFT = new DragHandle(points, this.strokes, this.Id.ToString());
                this.strokes.Add(TOP_LEFT);
            }
            if (BOTTOM_LEFT == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X) - 4, Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y) + 4));
                BOTTOM_LEFT = new DragHandle(points, this.strokes, this.Id.ToString());
                this.strokes.Add(BOTTOM_LEFT);
            }
            if (TOP_RIGHT == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X) + 4, Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y) - 4));
                TOP_RIGHT = new DragHandle(points, this.strokes, this.Id.ToString());
                this.strokes.Add(TOP_RIGHT);
            }
            if (BOTTOM_RIGHT == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X) + 4, Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y) + 4));
                BOTTOM_RIGHT = new DragHandle(points, this.strokes, this.Id.ToString());
                this.strokes.Add(BOTTOM_RIGHT);
            }
        }

        public override void deleteDragHandles()
        {
            if (this.TOP_LEFT != null)
            {
                if (this.strokes.has(TOP_LEFT.Id.ToString()))
                    this.strokes.Remove(this.strokes.get(TOP_LEFT.Id.ToString()));

                this.TOP_LEFT = null;
            }
            if (this.BOTTOM_LEFT != null)
            {
                if (this.strokes.has(BOTTOM_LEFT.Id.ToString()))
                    this.strokes.Remove(this.strokes.get(BOTTOM_LEFT.Id.ToString()));

                this.BOTTOM_LEFT = null;
            }
            if (this.TOP_RIGHT != null)
            {
                if (this.strokes.has(TOP_RIGHT.Id.ToString()))
                    this.strokes.Remove(this.strokes.get(TOP_RIGHT.Id.ToString()));

                this.TOP_RIGHT = null;
            }
            if (this.BOTTOM_RIGHT != null)
            {
                if (this.strokes.has(BOTTOM_RIGHT.Id.ToString()))
                    this.strokes.Remove(this.strokes.get(BOTTOM_RIGHT.Id.ToString()));

                this.BOTTOM_RIGHT = null;
            }
        }

        public void addAnchorPoints()
        {
            if (!this.strokes.has(this.Id.ToString())) return;

            var topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            double height = Math.Abs(this.StylusPoints[0].Y - this.StylusPoints[1].Y);
            double width = Math.Abs(this.StylusPoints[0].X - this.StylusPoints[1].X);
            
            int index = this.strokes.IndexOf(this.strokes.get(Id.ToString()));
            if (TOP == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint(topLeft.X + width / 2, topLeft.Y));
                TOP = new AnchorPoint(points, this.strokes, this.Id.ToString());
                this.strokes.Insert(index, TOP);
            }
            if (BOTTOM == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint(topLeft.X + width / 2, topLeft.Y + height));
                BOTTOM = new AnchorPoint(points, this.strokes, this.Id.ToString());
                this.strokes.Insert(index, BOTTOM);
            }
            if (LEFT == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint(topLeft.X, topLeft.Y + height / 2));
                LEFT = new AnchorPoint(points, this.strokes, this.Id.ToString());
                this.strokes.Insert(index, LEFT);
            }
            if (RIGHT == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint(topLeft.X + width, topLeft.Y + height / 2));
                RIGHT = new AnchorPoint(points, this.strokes, this.Id.ToString());
                this.strokes.Insert(index, RIGHT);
            }

        }

        public void deleteAnchorPoints()
        {
            if (this.TOP != null)
            {
                if (this.strokes.has(TOP.Id.ToString()))
                    this.strokes.Remove(this.strokes.get(TOP.Id.ToString()));

                this.TOP = null;
            }
            if (this.BOTTOM != null)
            {
                if (this.strokes.has(BOTTOM.Id.ToString()))
                    this.strokes.Remove(this.strokes.get(BOTTOM.Id.ToString()));

                this.BOTTOM = null;
            }
            if (this.LEFT != null)
            {
                if (this.strokes.has(LEFT.Id.ToString()))
                    this.strokes.Remove(this.strokes.get(LEFT.Id.ToString()));

                this.LEFT = null;
            }
            if (this.RIGHT != null)
            {
                if (this.strokes.has(RIGHT.Id.ToString()))
                    this.strokes.Remove(this.strokes.get(RIGHT.Id.ToString()));

                this.RIGHT = null;
            }
        }

        public override void showAnchorPoints()
        {
            this.AnchorPointVisibility = true;
            this.Refresh();
        }

        public override void hideAnchorPoints()
        {
            this.AnchorPointVisibility = false;
            this.Refresh();
        }

        private new void Refresh()
        {
            if (strokes.has(this.Id.ToString()))
                ((ShapeStroke)strokes.get(this.Id.ToString())).deleteAnchorPoints();
            
            base.Refresh();
        }

        public override StrokeType getType()
        {
            return StrokeType.OBJECT;
        }

        public override bool isSelectable()
        {
            return true;
        }
    }
}
