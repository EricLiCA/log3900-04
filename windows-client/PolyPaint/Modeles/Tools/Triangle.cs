using PolyPaint.Modeles.Strokes;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Tools
{
    class Triangle : FormTool
    {
        public override string GetToolImage()
        {
            return "/Resources/triangle-outline.png";
        }

        public override string GetToolName()
        {
            return "triangle";
        }

        public override string GetToolTooltip()
        {
            return "Triangle";
        }

        public override Stroke InstantiateForm(StylusPointCollection pts, CustomStrokeCollection strokes, Color color)
        {
            return new BaseTrangleStroke(pts, strokes, color);
        }
    }
}
