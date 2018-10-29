using PolyPaint.Modeles.Outils;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Tools
{
    class Rectangle : Tool
    {
        private bool IsDrawing;
        private Point MouseLeftDownPoint;
        private Stroke ActiveStroke;

        public override string GetToolImage()
        {
            return "/Resources/square-outline.png";
        }

        public override string GetToolName()
        {
            return "rectangle";
        }

        public override string GetToolTooltip()
        {
            return "Rectangle";
        }

        public override void MouseDown(Point point, StrokeCollection strokes)
        {
            IsDrawing = true;
            MouseLeftDownPoint = point;
        }

        public override void MouseMove(Point point, StrokeCollection strokes, Color selectedColor)
        {
            if (!IsDrawing) return;
            
            StylusPointCollection pts = new StylusPointCollection();
            pts.Add(new StylusPoint(MouseLeftDownPoint.X, MouseLeftDownPoint.Y));
            pts.Add(new StylusPoint(point.X, point.Y));

            if (ActiveStroke != null)
                strokes.Remove(ActiveStroke);

            ActiveStroke = new RectangleStroke(pts);
            ActiveStroke.DrawingAttributes.Color = selectedColor;
            strokes.Add(ActiveStroke);
        }

        public override void MouseUp(Point point, StrokeCollection strokes)
        {
            if (ActiveStroke != null)
            {
                strokes.Remove(ActiveStroke);
                strokes.Add(ActiveStroke.Clone());
            }
            IsDrawing = false;
        }
    }

    class RectangleStroke : Stroke
    {
        public RectangleStroke(StylusPointCollection pts) : base(pts)
        {
            this.StylusPoints = pts;
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            if (drawingContext == null)
            {
                throw new ArgumentNullException("drawingContext");
            }
            if (null == drawingAttributes)
            {
                throw new ArgumentNullException("drawingAttributes");
            }

            DrawingAttributes originalDa = drawingAttributes.Clone();
            SolidColorBrush fillBrush = new SolidColorBrush(drawingAttributes.Color);
            fillBrush.Freeze();
            Pen outlinePen = new Pen(new SolidColorBrush(Colors.Black), 2);
            outlinePen.Freeze();

            drawingContext.DrawRectangle(fillBrush, outlinePen, new Rect(this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint()));

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
                    drawingContext.DrawLine(outlinePen, point, secondPoint);
                    return;
                }

                //string textLeft = word;
                //do
                //{
                //    string[] subWords = word.Split(' ');
                //    subWords = subWords.SkipWhile(subWord => subWord == "").ToArray();

                //    FormattedText text = new FormattedText("", CultureInfo.CurrentCulture, FlowDirection.LeftToRight, new Typeface("Verdana"), wordSize, Brushes.Black);
                //    FormattedText verifiedText;
                //    bool wordFits = false;
                //    int amount = 0;
                //    do
                //    {
                //        if (!wordFits && subWords[0].Length == amount)
                //        {
                //            wordFits = true;
                //            amount = 1;
                //        } else
                //        {
                //            amount += 1;
                //        }

                //        verifiedText = text;
                //        string toWrite = wordFits ? String.Join(" ", subWords.Take(amount)) : String.Join("", subWords[0].Take(amount));
                //        text = new FormattedText(toWrite, CultureInfo.CurrentCulture, FlowDirection.LeftToRight, new Typeface("Verdana"), wordSize, Brushes.Black);
                //    } while (text.Width < bottomRight.X - topLeft.X);

                //    if (wordFits)
                //    {
                //        textLeft = String.Join(" ", subWords.Skip(amount - 1).ToArray());
                //    } else
                //    {
                //        subWords[0] = String.Join("", subWords[0].Skip(amount - 1));
                //        textLeft = String.Join(" ", subWords);
                //    }

                //    if (verifiedText.Text == "") break;
                //    drawingContext.DrawText(verifiedText, point);
                //    line += 1;

                //} while (word.Length > 0);

                FormattedText text = new FormattedText(word, CultureInfo.CurrentCulture, FlowDirection.LeftToRight, new Typeface("Verdana"), wordSize, Brushes.Black);
                text.MaxTextWidth = bottomRight.X - topLeft.X;
                text.MaxTextHeight = bottomRight.Y - point.Y;
                drawingContext.DrawText(text, point);
                line += ((int)text.Height % wordSize) / 3;
            });
        }
    }
}
