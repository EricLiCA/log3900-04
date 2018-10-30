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
    class BaseRectangleStroke : ShapeStroke
    {
        public BaseRectangleStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {

        }

        public override bool HitTest(Point point)
        {
            Point topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomRight = new Point(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            
            return point.X > topLeft.X && point.X < bottomRight.X && point.Y > topLeft.Y && point.Y < bottomRight.Y;
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            DrawingAttributes originalDa = drawingAttributes.Clone();
            SolidColorBrush fillBrush = new SolidColorBrush(drawingAttributes.Color);
            Pen outlinePen = new Pen(new SolidColorBrush(Colors.Black), 2);
            
            if (this.isSelected())
            {
                Pen selectedPen = new Pen(new SolidColorBrush(Colors.GreenYellow), 10);
                selectedPen.Freeze();
                drawingContext.DrawRectangle(null, selectedPen, new Rect(this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint()));
            }

            //if (this.isEditing())
            //{
            //    Pen selectedPen = new Pen(new SolidColorBrush(Colors.Blue), 10);
            //    selectedPen.Freeze();
            //    drawingContext.DrawRectangle(null, selectedPen, new Rect(this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint()));
            //}

            drawingContext.DrawRectangle(fillBrush, outlinePen, new Rect(this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint()));

            if (this.isEditing())
            {
                this.addDragHandles();
            }
        }
    }
}
