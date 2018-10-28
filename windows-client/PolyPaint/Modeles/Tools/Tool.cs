﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Ink;

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

        public abstract void MouseDown(Point point, StrokeCollection strokes);
        public abstract void MouseMove(Point point, StrokeCollection strokes);
        public abstract void MouseUp(Point point, StrokeCollection strokes);
    }
}
