
using System.Windows;
using System.Windows.Ink;
using System.Windows.Media;

namespace PolyPaint.Modeles.Outils
{
    abstract class Tool
    {
        public string ToolName { get => this.GetToolName(); }
        public string ToolImage { get => this.GetToolImage(); }
        public string ToolTooltip { get => this.GetToolTooltip(); }

        public abstract string GetToolName();
        public abstract string GetToolImage();
        public abstract string GetToolTooltip();

        public abstract void MouseDown(Point point, StrokeCollection strokes);
        public abstract void MouseMove(Point point, StrokeCollection strokes, Color selectedColor);
        public abstract void MouseUp(Point point, StrokeCollection strokes);

        public void MouseMove(Point point, StrokeCollection strokes)
        {
            this.MouseMove(point, strokes, Colors.Black);
        }
    }
}
