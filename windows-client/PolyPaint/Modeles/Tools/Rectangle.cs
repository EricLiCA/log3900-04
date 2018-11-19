using PolyPaint.Modeles.Strokes;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Tools
{
    class Rectangle : FormTool
    {
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

        public override Stroke InstantiateForm(StylusPointCollection pts, CustomStrokeCollection strokes, Color color)
        {
            return new BaseRectangleStroke(pts, strokes, color);
        }
    }
}
