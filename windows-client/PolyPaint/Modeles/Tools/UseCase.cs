using PolyPaint.Modeles.Strokes;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Tools
{
    class UseCase : FormTool
    {

        public override string GetToolImage()
        {
            return "/Resources/useCase-tool.png";
        }

        public override string GetToolName()
        {
            return "useCase";
        }

        public override string GetToolTooltip()
        {
            return "Use Case";
        }

        public override Stroke InstantiateForm(StylusPointCollection pts, CustomStrokeCollection strokes, Color color)
        {
            return new UseCaseStroke(pts, strokes);
        }
    }
}
