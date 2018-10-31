using System;
using System.Globalization;
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

            int wordSize = 18;
            Point center = new Point((topLeft.X + bottomRight.X) / 2, -wordSize + (topLeft.Y + bottomRight.Y) / 2);

            FormattedText text = new FormattedText(textContent, CultureInfo.CurrentCulture, FlowDirection.LeftToRight, new Typeface("Verdana"), wordSize, Brushes.Black);
            text.MaxTextWidth = bottomRight.X - center.X;
            text.MaxTextHeight = bottomRight.Y - center.Y;
            // TODO: Fix Origin text point. For now its just an estimation
            center.X = 0.85 * center.X;
            drawingContext.DrawText(text, center);
        }
    }
}
