using PolyPaint.Modeles.Outils;
using PolyPaint.Modeles.Strokes;
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

        public override void MouseDown(Point point, CustomStrokeCollection strokes)
        {
            IsDrawing = true;
            MouseLeftDownPoint = point;
        }

        public override void MouseMove(Point point, CustomStrokeCollection strokes, Color selectedColor)
        {
            if (!IsDrawing) return;
            
            StylusPointCollection pts = new StylusPointCollection();
            pts.Add(new StylusPoint(MouseLeftDownPoint.X, MouseLeftDownPoint.Y));
            pts.Add(new StylusPoint(point.X, point.Y));

            if (ActiveStroke != null)
                strokes.Remove(ActiveStroke);

            ActiveStroke = new BaseElipseStroke(pts, strokes);
            ActiveStroke.DrawingAttributes.Color = selectedColor;
            strokes.Add(ActiveStroke);
        }

        public override void MouseUp(Point point, CustomStrokeCollection strokes)
        {
            if (ActiveStroke != null)
            {
                strokes.Remove(ActiveStroke);
                strokes.Add(ActiveStroke.Clone());
            }
            IsDrawing = false;
        }
    }
}
