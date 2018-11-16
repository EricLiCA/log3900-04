using PolyPaint.Modeles.Outils;
using PolyPaint.Modeles.Strokes;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Tools
{
    abstract class FormTool : Tool
    {
        private bool IsDrawing;
        private Point MouseLeftDownPoint;
        private Stroke ActiveStroke;

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

            ActiveStroke = InstantiateForm(pts, strokes, selectedColor);
            strokes.Add(ActiveStroke);
        }

        public override void MouseUp(Point point, CustomStrokeCollection strokes)
        {
            if (ActiveStroke != null)
            {
                strokes.Remove(ActiveStroke);
                var clone = ActiveStroke.Clone();
                if (clone is TextStroke)
                    ((TextStroke)clone).showBorder = false;

                strokes.Add(clone);
                ((CustomStroke)clone).Select();
                EditionSocket.AddStroke(((Savable)clone).toJson());
            }
            IsDrawing = false;
        }

        public abstract Stroke InstantiateForm(StylusPointCollection pts, CustomStrokeCollection strokes, Color color);
    }
}
