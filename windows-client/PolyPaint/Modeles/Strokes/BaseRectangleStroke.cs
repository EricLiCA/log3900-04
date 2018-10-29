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

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            DrawingAttributes originalDa = drawingAttributes.Clone();
            SolidColorBrush fillBrush = new SolidColorBrush(drawingAttributes.Color);
            fillBrush.Freeze();
            Pen outlinePen = new Pen(new SolidColorBrush(Colors.Black), 2);
            outlinePen.Freeze();

            drawingContext.DrawRectangle(fillBrush, outlinePen, new Rect(this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint()));
        }
    }
}
