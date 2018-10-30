using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Strokes
{
    class BaseRectangleStroke : CustomStroke
    {
        public BaseRectangleStroke(StylusPointCollection pts) : base(pts)
        {

        }

        public override StrokeType getType()
        {
            return StrokeType.OBJECT;
        }

        public override bool HitTest(Point point)
        {
            Point topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomRight = new Point(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));

            Console.WriteLine(point);

            return point.X > topLeft.X && point.X < bottomRight.X && point.Y > topLeft.Y && point.Y < bottomRight.Y;
        }

        public override bool isSelectable()
        {
            return true;
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            DrawingAttributes originalDa = drawingAttributes.Clone();
            SolidColorBrush fillBrush = new SolidColorBrush(drawingAttributes.Color);
            Pen outlinePen = new Pen(new SolidColorBrush(Colors.Black), 2);

            drawingContext.DrawRectangle(fillBrush, outlinePen, new Rect(this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint()));

            if (this.isSelected())
            {
                Pen selectedPen = new Pen(new SolidColorBrush(Colors.GreenYellow), 5);
                selectedPen.Freeze();
                drawingContext.DrawRectangle(null, selectedPen, new Rect(this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint()));
                
            }
        }
    }
}
