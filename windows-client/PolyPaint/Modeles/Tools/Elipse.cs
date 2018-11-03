using PolyPaint.Modeles.Strokes;
using System.Windows.Ink;
using System.Windows.Input;

namespace PolyPaint.Modeles.Tools
{
    class Elipse : FormTool
    {
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

        public override Stroke InstantiateForm(StylusPointCollection pts, CustomStrokeCollection strokes)
        {
            return new BaseElipseStroke(pts, strokes);
        }
    }
}
