using System;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Strokes
{
    class BaseLine : CustomStroke
    {
        DragHandle FIRST_POINT;
        DragHandle SECOND_POINT;

        public BaseLine(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {

        }

        public override void addDragHandles()
        {
            if (FIRST_POINT == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint(this.StylusPoints[0].X, this.StylusPoints[0].Y));
                FIRST_POINT = new DragHandle(points, this.strokes, this.Id.ToString());
                this.strokes.Add(FIRST_POINT);
            }
            if (SECOND_POINT == null)
            {
                var points = new StylusPointCollection();
                points.Add(new StylusPoint( this.StylusPoints[1].X, this.StylusPoints[1].Y));
                SECOND_POINT = new DragHandle(points, this.strokes, this.Id.ToString());
                this.strokes.Add(SECOND_POINT);
            }
        }

        public override void deleteDragHandles()
        {
            if (this.FIRST_POINT != null)
            {
                if (this.strokes.has(FIRST_POINT.Id.ToString()))
                    this.strokes.Remove(this.strokes.get(FIRST_POINT.Id.ToString()));

                this.FIRST_POINT = null;
            }
            if (this.SECOND_POINT != null)
            {
                if (this.strokes.has(SECOND_POINT.Id.ToString()))
                    this.strokes.Remove(this.strokes.get(SECOND_POINT.Id.ToString()));

                this.SECOND_POINT = null;
            }
        }

        public override StrokeType getType()
        {
            return StrokeType.OBJECT;
        }

        public override void hideAnchorPoints()
        {
            // A Line does not have anchor points
        }

        public override bool HitTest(Point point)
        {
            Point topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomRight = new Point(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));

            return point.X > topLeft.X && point.X < bottomRight.X && point.Y > topLeft.Y && point.Y < bottomRight.Y;
        }

        public override bool isSelectable()
        {
            return true;
        }

        public override void showAnchorPoints()
        {
            // A Line does not have anchor points
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            DrawingAttributes originalDa = drawingAttributes.Clone();
            Pen outlinePen = new Pen(new SolidColorBrush(drawingAttributes.Color), 2);

            if (this.isSelected())
            {
                Pen selectedPen = new Pen(new SolidColorBrush(Colors.GreenYellow), 10);
                selectedPen.Freeze();
                drawingContext.DrawLine(selectedPen, this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint());
            }

            drawingContext.DrawLine(outlinePen, this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint());

            if (this.isEditing())
            {
                this.addDragHandles();
            }
        }
    }
}
