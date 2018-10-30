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
    public class DragHandle : CustomStroke
    {

        public readonly string ParentId;

        public DragHandle(StylusPointCollection pts, CustomStrokeCollection strokes, string parentId) : base(pts, strokes)
        {
            this.ParentId = parentId;
        }

        public override void addDragHandles()
        {
            // A drag handle can't have drag handles
        }

        public override void deleteDragHandles()
        {
            // A drag handle can't have drag handles
        }

        public override StrokeType getType()
        {
            return StrokeType.DRAG_HANDLE;
        }

        public override void hideAnchorPoints()
        {
            // A Drag Handle does not have anchor points
        }

        public override bool HitTest(Point point)
        {
            return 6 > Math.Sqrt(Math.Pow(point.X - this.StylusPoints[0].X, 2) + Math.Pow(point.Y - this.StylusPoints[0].Y, 2));
        }

        public override bool isSelectable()
        {
            return false;
        }

        public override void showAnchorPoints()
        {
            // A Drag Handle does not have anchor points
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            DrawingAttributes originalDa = drawingAttributes.Clone();
            Pen pen = new Pen(new SolidColorBrush(Colors.Gray), 1.5);

            Point up = this.StylusPoints[0].ToPoint();
            up.Y = up.Y - 6;
            Point down = this.StylusPoints[0].ToPoint();
            down.Y = down.Y + 6;
            Point left = this.StylusPoints[0].ToPoint();
            left.X = left.X - 6;
            Point right = this.StylusPoints[0].ToPoint();
            right.X = right.X + 6;
            drawingContext.DrawLine(pen, left, right);
            drawingContext.DrawLine(pen, up, down);
        }
    }
}
