using PolyPaint.Modeles.Outils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles.Tools
{
    class Pencil : BasicCanvasTool
    {
        public override string GetToolImage()
        {
            return "/Resources/pencil-tool.png";
        }

        public override string GetToolName()
        {
            return "pencil";
        }

        public override string GetToolTooltip()
        {
            return "Pencil";
        }
    }
}
