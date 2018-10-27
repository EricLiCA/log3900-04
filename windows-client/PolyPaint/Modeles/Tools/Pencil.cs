using PolyPaint.Modeles.Outils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles.Tools
{
    class Pencil : Tool
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

        public override void OnDrag()
        {
            throw new NotImplementedException();
        }

        public override void OnMouseDown()
        {
            throw new NotImplementedException();
        }

        public override void OnMouseUp()
        {
            throw new NotImplementedException();
        }
    }
}
