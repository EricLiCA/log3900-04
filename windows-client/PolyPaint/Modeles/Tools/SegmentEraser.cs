using PolyPaint.Modeles.Outils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles.Tools
{
    class SegmentEraser : BasicCanvasTool
    {
        public override string GetToolImage()
        {
            return "/Resources/eraser-tool.png";
        }

        public override string GetToolName()
        {
            return "segment_eraser";
        }

        public override string GetToolTooltip()
        {
            return "Segment Eraser";
        }
    }
}
