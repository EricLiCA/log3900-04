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
        Guid TOP_LEFT = Guid.NewGuid();
        Guid BOTTOM_LEFT = Guid.NewGuid();
        Guid TOP_RIGHT = Guid.NewGuid();
        Guid BOTTOM_RIGHT = Guid.NewGuid();

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
            this.deleteDragHandles();

            var pointsTopLeft = new StylusPointCollection();
            pointsTopLeft.Add(new StylusPoint(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X) - 4, Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y) - 4));
            this.strokes.Add(new DragHandle(pointsTopLeft, this.strokes, TOP_LEFT, this.Id.ToString()));

            var pointsTopRight = new StylusPointCollection();
            pointsTopRight.Add(new StylusPoint(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X) - 4, Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y) + 4));
            this.strokes.Add(new DragHandle(pointsTopRight, this.strokes, BOTTOM_LEFT, this.Id.ToString()));

            var pointsBottomLeft = new StylusPointCollection();
            pointsBottomLeft.Add(new StylusPoint(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X) + 4, Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y) - 4));
            this.strokes.Add(new DragHandle(pointsBottomLeft, this.strokes, TOP_RIGHT, this.Id.ToString()));

            var pointsBottomRight = new StylusPointCollection();
            pointsBottomRight.Add(new StylusPoint(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X) + 4, Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y) + 4));
            this.strokes.Add(new DragHandle(pointsBottomRight, this.strokes, BOTTOM_RIGHT, this.Id.ToString()));

        }

        public override void deleteDragHandles()
        {
            if (this.strokes.has(TOP_LEFT.ToString()))
                this.strokes.Remove(this.strokes.get(TOP_LEFT.ToString()));
            if (this.strokes.has(BOTTOM_LEFT.ToString()))
                this.strokes.Remove(this.strokes.get(BOTTOM_LEFT.ToString()));
            if (this.strokes.has(TOP_RIGHT.ToString()))
                this.strokes.Remove(this.strokes.get(TOP_RIGHT.ToString()));
            if (this.strokes.has(BOTTOM_RIGHT.ToString()))
                this.strokes.Remove(this.strokes.get(BOTTOM_RIGHT.ToString()));
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
                points.Add(new StylusPoint(topLeft.X + width / 2, topLeft.Y - 2));
                TOP = new AnchorPoint(points, this.strokes, this.Id.ToString());
                this.strokes.Insert(index, TOP);
            }
            if (BOTTOM == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint(topLeft.X + width / 2, topLeft.Y + height + 2));
                BOTTOM = new AnchorPoint(points, this.strokes, this.Id.ToString());
                this.strokes.Insert(index, BOTTOM);
            }
            if (LEFT == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint(topLeft.X - 2, topLeft.Y + height / 2));
                LEFT = new AnchorPoint(points, this.strokes, this.Id.ToString());
                this.strokes.Insert(index, LEFT);
            }
            if (RIGHT == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint(topLeft.X + width + 2, topLeft.Y + height / 2));
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

        public override void Move(StylusPointCollection newPoints)
        {
            this.StylusPoints = newPoints;
            this.Refresh();
        }

        public override void handleMoved(Guid id, Point point)
        {
            Point topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomRight = new Point(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            
            if (id.ToString() == TOP_LEFT.ToString())
            {
                if (point.Y >= bottomRight.Y && point.X >= bottomRight.X)
                {
                    var temp = TOP_LEFT;
                    TOP_LEFT = BOTTOM_RIGHT;
                    BOTTOM_RIGHT = temp;
                }
                else if (point.Y >= bottomRight.Y)
                {
                    var temp = TOP_LEFT;
                    TOP_LEFT = BOTTOM_LEFT;
                    BOTTOM_LEFT = temp;
                }
                else if (point.X >= bottomRight.X)
                {
                    var temp = TOP_LEFT;
                    TOP_LEFT = TOP_RIGHT;
                    TOP_RIGHT = temp;
                }

                topLeft.X = point.X;
                topLeft.Y = point.Y;
            }
            else if (id.ToString() == TOP_RIGHT.ToString())
            {
                if (point.Y >= bottomRight.Y && point.X <= topLeft.X)
                {
                    var temp = TOP_RIGHT;
                    TOP_RIGHT = BOTTOM_LEFT;
                    BOTTOM_LEFT = temp;
                }
                else if (point.Y >= bottomRight.Y)
                {
                    var temp = TOP_RIGHT;
                    TOP_RIGHT = BOTTOM_RIGHT;
                    BOTTOM_RIGHT = temp;
                }
                else if (point.X <= topLeft.X)
                {
                    var temp = TOP_RIGHT;
                    TOP_RIGHT = TOP_LEFT;
                    TOP_LEFT = temp;
                }

                bottomRight.X = point.X;
                topLeft.Y = point.Y;
            }
            else if (id.ToString() == BOTTOM_LEFT.ToString())
            {
                if (point.Y <= topLeft.Y && point.X >= bottomRight.X)
                {
                    var temp = BOTTOM_LEFT;
                    BOTTOM_LEFT = TOP_RIGHT;
                    TOP_RIGHT = temp;
                }
                else if (point.Y <= topLeft.Y)
                {
                    var temp = BOTTOM_LEFT;
                    BOTTOM_LEFT = TOP_LEFT;
                    TOP_LEFT = temp;
                }
                else if (point.X >= bottomRight.X)
                {
                    var temp = BOTTOM_LEFT;
                    BOTTOM_LEFT = BOTTOM_RIGHT;
                    BOTTOM_RIGHT = temp;
                }

                topLeft.X = point.X;
                bottomRight.Y = point.Y;
            }
            else if (id.ToString() == BOTTOM_RIGHT.ToString())
            {
                if (point.Y <= topLeft.Y && point.X <= topLeft.X)
                {
                    var temp = BOTTOM_RIGHT;
                    BOTTOM_RIGHT = TOP_LEFT;
                    TOP_LEFT = temp;
                }
                else if (point.Y <= topLeft.Y)
                {
                    var temp = BOTTOM_RIGHT;
                    BOTTOM_RIGHT = TOP_RIGHT;
                    TOP_RIGHT = temp;
                }
                else if (point.X <= topLeft.X)
                {
                    var temp = BOTTOM_RIGHT;
                    BOTTOM_RIGHT = BOTTOM_LEFT;
                    BOTTOM_LEFT = temp;
                }

                bottomRight.X = point.X;
                bottomRight.Y = point.Y;
            }

            StylusPointCollection newPoints = new StylusPointCollection();
            newPoints.Add(new StylusPoint(topLeft.X, topLeft.Y));
            newPoints.Add(new StylusPoint(bottomRight.X, bottomRight.Y));

            this.StylusPoints = newPoints;
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
