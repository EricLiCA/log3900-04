using PolyPaint.Modeles.Outils;
using System;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Tools
{
    class Elipse : Tool
    {
        private bool IsDrawing;
        private Point MouseLeftDownPoint;
        private Stroke ActiveStroke;

        public override string GetToolImage()
        {
            return "/Resources/circle-outline.png";
        }

        public override string GetToolName()
        {
            return "elipse";
        }

        public override string GetToolTooltip()
        {
            return "Elipse";
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

            ActiveStroke = new ElipseStroke(pts);
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

    class ElipseStroke : Stroke
    {
        public ElipseStroke(StylusPointCollection pts) : base(pts)
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

            StylusPoint stp = this.StylusPoints[0];
            StylusPoint sp = this.StylusPoints[1];

            drawingContext.DrawEllipse(fillBrush, outlinePen, new Point((sp.X + stp.X) / 2.0, (sp.Y + stp.Y) / 2.0), Math.Abs(sp.X - stp.X) / 2, Math.Abs(sp.Y - stp.Y) / 2);
        }
    }
}
