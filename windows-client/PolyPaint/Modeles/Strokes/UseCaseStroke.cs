using Newtonsoft.Json;
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
    class UseCaseStroke : BaseElipseStroke, Textable
    {
        public List<string> textContent;

        public UseCaseStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {
            this.textContent = new List<string>
            {
                "Use Case"
            };
        }

        public UseCaseStroke(StylusPointCollection pts, CustomStrokeCollection strokes, List<string> Content) : base(pts, strokes)
        {
            this.textContent = Content;
        }

        public UseCaseStroke(string id, int index, StylusPointCollection pts, CustomStrokeCollection strokes, List<string> Content) : base(id, index, pts, strokes, Colors.White)
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
            Pen Pen = new Pen(new SolidColorBrush(Colors.Black), 2);
            Pen.Freeze();

            Point topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomRight = new Point(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));

            drawingContext.PushTransform(new RotateTransform(Rotation, Center.X, Center.Y));

            if ( bottomRight.X - topLeft.X > 0 && bottomRight.Y - topLeft.Y > 0)
            {
                int wordSize = 17;
                FormattedText text = new FormattedText(this.GetText(), CultureInfo.CurrentCulture, FlowDirection.LeftToRight, new Typeface("Verdana"), wordSize, Brushes.Black)
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

        public override StrokeType StrokeType() => Strokes.StrokeType.USE;

        public static List<string> toServerStyle(List<string> content)
        {
            List<string> returnList = new List<string>() { "" };
            for (int index = 0; index < content.Count; index++)
            {
                if (content[index] == "--")
                {
                    returnList.Add("");
                } else
                {
                    if (returnList.Last() != "")
                        returnList[returnList.Count - 1] += "\n";

                    returnList[returnList.Count - 1] += content[index];
                }
            }
            return returnList;
        }

        public static List<string> fromServerStyle(List<string> content)
        {
            List<string> returnList = new List<string>() {};

            if (content != null)
                for (int index = 0; index < content.Count; index++)
                {
                    if (returnList.Count > 0)
                        returnList.Add("--");

                    if (content[index] == "") continue;

                    var sections = content[index].Split(new[] { "\n" }, StringSplitOptions.None);
                    for (int i = 0; i < sections.Length; i++)
                        returnList.Add(sections[i]);
                }
            else
                returnList.Add("");

            return returnList;
        }

        public override ShapeInfo GetShapeInfo()
        {
            return new TextableShapeInfo
            {
                Center = new ShapePoint() { X = this.Center.X, Y = this.Center.Y },
                Height = this.Height,
                Width = this.Width,
                Content  = toServerStyle( this.textContent ),
                Color = new ColorConverter().ConvertToString(this.DrawingAttributes.Color)
            };
        }
    }
}
