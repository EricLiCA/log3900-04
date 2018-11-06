
using PolyPaint.Modeles.Strokes;
using System.Windows;
using System.Windows.Media;

namespace PolyPaint.Modeles.Outils
{
    public abstract class Tool
    {
        public string ToolName { get => this.GetToolName(); }
        public string ToolImage { get => this.GetToolImage(); }
        public string ToolTooltip { get => this.GetToolTooltip(); }

        public abstract string GetToolName();
        public abstract string GetToolImage();
        public abstract string GetToolTooltip();

        public abstract void MouseDown(Point point, CustomStrokeCollection strokes);
        public abstract void MouseMove(Point point, CustomStrokeCollection strokes, Color selectedColor);
        public abstract void MouseUp(Point point, CustomStrokeCollection strokes);

        public void MouseMove(Point point, CustomStrokeCollection strokes)
        {
            this.MouseMove(point, strokes, Colors.Black);
        }
    }
}
