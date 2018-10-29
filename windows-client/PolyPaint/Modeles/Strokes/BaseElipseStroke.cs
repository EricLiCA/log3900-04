using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Strokes
{

    class BaseElipseStroke : CustomStroke
    {
        public BaseElipseStroke(StylusPointCollection pts) : base(pts)
        {
            this.StylusPoints = pts;
        }

        public override StrokeType getType()
        {
            return StrokeType.OBJECT;
        }

        public override bool isSelectable()
        {
            return true;
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            DrawingAttributes originalDa = drawingAttributes.Clone();
            SolidColorBrush fillBrush = new SolidColorBrush(drawingAttributes.Color);
            fillBrush.Freeze();
            Pen outlinePen = new Pen(new SolidColorBrush(Colors.Black), 2);
            outlinePen.Freeze();

            StylusPoint stp = this.StylusPoints[0];
            StylusPoint sp = this.StylusPoints[1];

            drawingContext.DrawEllipse(fillBrush, outlinePen, new Point((sp.X + stp.X) / 2.0, (sp.Y + stp.Y) / 2.0), Math.Abs(sp.X - stp.X) / 2, Math.Abs(sp.Y - stp.Y) / 2);
        }
    }
}
