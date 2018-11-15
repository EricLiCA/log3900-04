using PolyPaint.Modeles.Strokes;
using System.Windows.Ink;
using System.Windows.Input;

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

        public override Stroke InstantiateForm(StylusPointCollection pts, CustomStrokeCollection strokes)
        {
            return new UseCaseStroke(pts, strokes);
        }
    }
}
