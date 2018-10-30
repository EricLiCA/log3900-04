using PolyPaint.Modeles.Outils;
using PolyPaint.Modeles.Strokes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Media;

namespace PolyPaint.Modeles.Tools
{
    abstract class BasicCanvasTool : Tool
    {
        public override void MouseMove(Point point, CustomStrokeCollection strokes, Color selectedColor)
        {
            // Is a base canvas fonctionnality and is treated by the canvas
        }

        public override void MouseDown(Point point, CustomStrokeCollection strokes)
        {
            // Is a base canvas fonctionnality and is treated by the canvas
        }

        public override void MouseUp(Point point, CustomStrokeCollection strokes)
        {
            // Is a base canvas fonctionnality and is treated by the canvas
        }
    }
}
