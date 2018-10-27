using PolyPaint.Modeles.Outils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles.Tools
{
    class Lasso : Tool
    {
        public override string GetToolImage()
        {
            return "/Resources/lasso-tool.png";
        }

        public override string GetToolName()
        {
            return "lasso";
        }

        public override string GetToolTooltip()
        {
            return "Lasso";
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
