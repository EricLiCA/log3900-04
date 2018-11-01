using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Strokes
{
    class UseCaseStroke : BaseElipseStroke, Textable
    {
        public string textContent;

        public UseCaseStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {
            this.textContent = "Use Case";
        }

        public string GetText()
        {
            return textContent;
        }

        public void SetText(string text)
        {
            this.textContent = text;
            this.Refresh();
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            base.DrawCore(drawingContext, drawingAttributes);

            DrawingAttributes originalDa = drawingAttributes.Clone();
            Pen Pen = new Pen(new SolidColorBrush(Colors.Black), 2);
            Pen.Freeze();

            Point topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomRight = new Point(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));

            drawingContext.PushTransform(new RotateTransform(Rotation, Center.X, Center.Y));

            if ( bottomRight.X - topLeft.X > 0 && bottomRight.Y - topLeft.Y > 0)
            {
                int wordSize = 18;
                FormattedText text = new FormattedText(textContent, CultureInfo.CurrentCulture, FlowDirection.LeftToRight, new Typeface("Verdana"), wordSize, Brushes.Black)
                {
                    TextAlignment = TextAlignment.Center,
                    MaxTextWidth = bottomRight.X - topLeft.X,
                    MaxTextHeight = bottomRight.Y - topLeft.Y
                };
                Point center = new Point((topLeft.X + bottomRight.X) / 2, (topLeft.Y + bottomRight.Y) / 2);
                Point textOrigin = new Point(center.X - text.MaxTextWidth / 2, center.Y - text.Height / 2);
                drawingContext.DrawText(text, textOrigin);
            }
            
            drawingContext.Pop();
        }
    }
}
