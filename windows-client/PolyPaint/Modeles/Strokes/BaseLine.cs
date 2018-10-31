using System;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Strokes
{
    class BaseLine : CustomStroke
    {
        Guid FIRST_POINT = Guid.NewGuid();
        Guid SECOND_POINT = Guid.NewGuid();

        public BaseLine(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {
            Console.WriteLine(FIRST_POINT + "   -   " + SECOND_POINT);
        }

        public override void addDragHandles()
        {
            if (!this.strokes.has(this.Id.ToString())) return;
            this.deleteDragHandles();

            var pointsFirst = new StylusPointCollection();
            pointsFirst.Add(new StylusPoint(this.StylusPoints[0].X, this.StylusPoints[0].Y));
            this.strokes.Add(new DragHandle(pointsFirst, this.strokes, FIRST_POINT, this.Id.ToString()));
            
            var pointsSecond = new StylusPointCollection();
            pointsSecond.Add(new StylusPoint( this.StylusPoints[1].X, this.StylusPoints[1].Y));
            this.strokes.Add(new DragHandle(pointsSecond, this.strokes, SECOND_POINT, this.Id.ToString()));

        }

        public override void deleteDragHandles()
        {
            if (this.strokes.has(FIRST_POINT.ToString()))
                this.strokes.Remove(this.strokes.get(FIRST_POINT.ToString()));
            if (this.strokes.has(SECOND_POINT.ToString()))
                this.strokes.Remove(this.strokes.get(SECOND_POINT.ToString()));
        }

        public override StrokeType getType()
        {
            return StrokeType.OBJECT;
        }

        public override void hideAnchorPoints()
        {
            // A Line does not have anchor points
        }

        public override void showAnchorPoints()
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

        public override void Move(StylusPointCollection newPoints)
        {
            this.StylusPoints = newPoints;
            this.Refresh();
        }

        public override void handleMoved(Guid id, Point point)
        {
            Console.WriteLine(id);
            if (this.FIRST_POINT.ToString() == id.ToString())
            {
                this.StylusPoints[0] = new StylusPoint(point.X, point.Y);
                this.Refresh();
            }
            else if (this.SECOND_POINT.ToString() == id.ToString())
            {
                this.StylusPoints[1] = new StylusPoint(point.X, point.Y);
                this.Refresh();
            }
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
