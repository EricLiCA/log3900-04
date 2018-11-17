using PolyPaint.Modeles.Strokes;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Tools
{
    class Person : FormTool
    {
        public override string GetToolImage()
        {
            return "/Resources/person.png";
        }

        public override string GetToolName()
        {
            return "actor";
        }

        public override string GetToolTooltip()
        {
            return "Actor";
        }

        public override Stroke InstantiateForm(StylusPointCollection pts, CustomStrokeCollection strokes, Color color)
        {
            return new PersonStroke(pts, strokes);
        }
    }
}
