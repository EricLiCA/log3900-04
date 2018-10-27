using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles.Outils
{
    abstract class Tool
    {
        public string ToolName { get => this.GetToolName(); }
        public string ToolImage { get => this.GetToolImage(); }
        public string ToolTooltip { get => this.GetToolTooltip(); }

        public abstract string GetToolName();
        public abstract string GetToolImage();
        public abstract string GetToolTooltip();

        public abstract void OnMouseDown();
        public abstract void OnDrag();
        public abstract void OnMouseUp();
    }
}
