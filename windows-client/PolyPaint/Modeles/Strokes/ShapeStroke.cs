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

        public ShapeStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {

        }

        public override void addDragHandles()
        {
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
