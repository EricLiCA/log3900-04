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
    class ClassStroke : BaseRectangleStroke
    {
        public ClassStroke(StylusPointCollection pts) : base(pts)
        {

        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            base.DrawCore(drawingContext, drawingAttributes);

            DrawingAttributes originalDa = drawingAttributes.Clone();
            Pen Pen = new Pen(new SolidColorBrush(Colors.Black), 2);
            Pen.Freeze();
            
            List<string> words = new List<string>();
            words.Add("Tree");
            words.Add("--");
            words.Add("trunk: Trunk");
            words.Add("branches: Branch[]");
            words.Add("--");
            words.Add("cut(): void");

            Point topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomRight = new Point(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            int wordSize = 18;

            int line = 0;
            words.ForEach(word =>
            {
                var point = topLeft;
                point.Y += wordSize * 1.25 * line;
                if (point.Y + wordSize * 1.25 > bottomRight.Y) return;

                if (word == "--")
                {
                    var secondPoint = bottomRight;
                    secondPoint.Y = point.Y;
                    drawingContext.DrawLine(Pen, point, secondPoint);
                    return;
                }

                FormattedText text = new FormattedText(word, CultureInfo.CurrentCulture, FlowDirection.LeftToRight, new Typeface("Verdana"), wordSize, Brushes.Black);
                text.MaxTextWidth = bottomRight.X - topLeft.X;
                text.MaxTextHeight = bottomRight.Y - point.Y;
                drawingContext.DrawText(text, point);
                line += ((int)text.Height % wordSize) / 3;
            });
        }
    }
}
