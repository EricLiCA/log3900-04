using PolyPaint.Modeles.Strokes;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Tools
{
    class TextTool : FormTool
    {
        public override string GetToolImage()
        {
            return "/Resources/format-letter-case.png";
        }

        public override string GetToolName()
        {
            return "textTool";
        }

        public override string GetToolTooltip()
        {
            return "Text Zone";
        }

        public override Stroke InstantiateForm(StylusPointCollection pts, CustomStrokeCollection strokes, Color color)
        {
            return new TextStroke(pts, strokes, true);
        }
    }
}
