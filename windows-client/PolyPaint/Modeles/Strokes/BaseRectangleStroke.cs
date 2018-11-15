using System;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Strokes
{
    class BaseRectangleStroke : ShapeStroke
    {
        public BaseRectangleStroke(StylusPointCollection pts, CustomStrokeCollection strokes, Color color) : base(pts, strokes, color)
        {

        }
        public BaseRectangleStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {

        }

        public BaseRectangleStroke(string id, int index, StylusPointCollection pts, CustomStrokeCollection strokes, Color color) : base(id, index, pts, strokes, color)
        {
        }

        public override bool HitTest(Point point)
        {
            Matrix antiRotationMatix = new Matrix();
            antiRotationMatix.RotateAt(-Rotation, Center.X, Center.Y);
            Point clickedLocal = antiRotationMatix.Transform(point);

            Point topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomRight = new Point(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));

            return clickedLocal.X > topLeft.X && clickedLocal.X < bottomRight.X && clickedLocal.Y > topLeft.Y && clickedLocal.Y < bottomRight.Y;
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {

            DrawingAttributes originalDa = drawingAttributes.Clone();
            SolidColorBrush fillBrush = (this is Textable) ? new SolidColorBrush(Colors.White) : new SolidColorBrush(this.Color);
            fillBrush.Freeze();
            Pen outlinePen = new Pen(new SolidColorBrush(Colors.Black), 1);

            drawingContext.PushTransform(new RotateTransform(Rotation, Center.X, Center.Y));

            if (this.isSelected())
            {
                Pen selectedPen = new Pen(new SolidColorBrush(Colors.GreenYellow), 5);
                selectedPen.Freeze();
                drawingContext.DrawRectangle(null, selectedPen, new Rect(this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint()));
            }

            if (this.AnchorPointVisibility)
            {
                this.addAnchorPoints();
            }

            drawingContext.DrawRectangle(fillBrush, outlinePen, new Rect(this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint()));

            if (this.isEditing())
            {
                this.addDragHandles();
            }

            drawingContext.Pop();
        }

        public override StrokeType StrokeType() => Strokes.StrokeType.RECTANGLE;
    }
}
