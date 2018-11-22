using PolyPaint.Modeles.Strokes;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Tools
{
    class ClassDiagram : FormTool
    {
        public override string GetToolImage()
        {
            return "/Resources/classDiagram-tool.png";
        }

        public override string GetToolName()
        {
            return "classDiagram";
        }

        public override string GetToolTooltip()
        {
            return "Class Diagram";
        }

        public override Stroke InstantiateForm(StylusPointCollection pts, CustomStrokeCollection strokes, Color color)
        {
            return new ClassStroke(pts, strokes);
        }
    }
}
