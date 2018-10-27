using PolyPaint.Modeles.Outils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles.Tools
{
    class ObjectEraser : Tool
    {
        public override string GetToolImage()
        {
            return "/Resources/eraser_variant-tool.png";
        }

        public override string GetToolName()
        {
            return "object_eraser";
        }

        public override string GetToolTooltip()
        {
            return "Object Eraser";
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
