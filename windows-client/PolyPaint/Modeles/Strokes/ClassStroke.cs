﻿using Newtonsoft.Json;
using PolyPaint.Modeles.Actions;
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
    class ClassStroke : BaseRectangleStroke, Textable
    {
        public List<string> textContent;

        public ClassStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {
            this.textContent = new List<string>
            {
                "Class title",
                "--",
                "Attribute",
                "--",
                "Operations()"
            };
        }

        public ClassStroke(StylusPointCollection pts, CustomStrokeCollection strokes, List<string> Content) : base(pts, strokes)
        {
            this.textContent = Content;
        }

        public ClassStroke(string id, int index, StylusPointCollection pts, CustomStrokeCollection strokes, List<string> Content) : base(id, index, pts, strokes, Colors.White)
        {
            this.textContent = Content;
        }

        public string GetText()
        {
            return textContent.Aggregate((a, b) => a + "\r\n" + b);
        }

        public void SetText(string text)
        {
            string before = this.toJson();
            this.textContent = text.Split(new[] { "\r\n" }, StringSplitOptions.None).ToList();
            this.Refresh();
            EditionSocket.EditStroke(this.toJson());
            Editeur.instance.Do(new EditStroke(this.Id.ToString(), before, this.toJson()));
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            base.DrawCore(drawingContext, drawingAttributes);

            DrawingAttributes originalDa = drawingAttributes.Clone();
            Pen Pen = new Pen(new SolidColorBrush(Colors.Black), 1);
            Pen.Freeze();

            Point topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomRight = new Point(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            int wordSize = 17;

            drawingContext.PushTransform(new RotateTransform(Rotation, Center.X, Center.Y));

            int line = 0;
            textContent.ForEach(textLine =>
            {
                var point = topLeft;
                point.Y += wordSize * 1.5 * line;
                if (point.Y + wordSize * 1.5 > bottomRight.Y) return;
                
                if (textLine == "--")
                {
                    var secondPoint = bottomRight;
                    secondPoint.Y = point.Y;
                    drawingContext.DrawLine(Pen, point, secondPoint);
                    return;
                }

                FormattedText text = new FormattedText(textLine, CultureInfo.CurrentCulture, FlowDirection.LeftToRight, new Typeface("Verdana"), wordSize, Brushes.Black);
                text.MaxTextWidth = bottomRight.X - topLeft.X;
                text.MaxTextHeight = bottomRight.Y - point.Y;
                if (line == 0)
                    text.TextAlignment = TextAlignment.Center;
                drawingContext.DrawText(text, point);
                line += ((int)text.Height % wordSize) / 3;
            });

            drawingContext.Pop();
        }

        public override StrokeType StrokeType() => Strokes.StrokeType.CLASS;

        public override ShapeInfo GetShapeInfo()
        {
            return new TextableShapeInfo
            {
                Center = new ShapePoint() { X = this.Center.X, Y = this.Center.Y},
                Height = this.Height,
                Width = this.Width,
                Content = UseCaseStroke.toServerStyle(this.textContent),
                Color = new ColorConverter().ConvertToString(this.DrawingAttributes.Color)
            };
        }
    }
}
