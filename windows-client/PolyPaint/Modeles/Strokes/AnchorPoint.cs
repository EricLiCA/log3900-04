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
    class AnchorPoint : CustomStroke
    {
        public readonly string ParentId;
        private bool hover = false;
        public bool Hover
        {
            get => hover;
            set
            {
                if (this.hover != value)
                {
                    this.hover = value;
                    this.Refresh();
                }
            }
        }

        public AnchorPoint(StylusPointCollection pts, CustomStrokeCollection strokes, string parentId) : base(pts, strokes)
        {
            this.ParentId = parentId;
        }

        public override void addDragHandles()
        {
            // An Anchor Point does not have handles
        }

        public override void deleteDragHandles()
        {
            // An Anchor Point does not have handles
        }

        public override StrokeType getType()
        {
            return StrokeType.ANCHOR_POINT;
        }

        public override void hideAnchorPoints()
        {
            // An Anchor Point does not have anchor points
        }

        public override bool HitTest(Point point)
        {
            return 10 > Math.Sqrt(Math.Pow(point.X - this.StylusPoints[0].X, 2) + Math.Pow(point.Y - this.StylusPoints[0].Y, 2));
        }

        public override bool isSelectable()
        {
            return false;
        }

        public override void showAnchorPoints()
        {
            // An Anchor Point does not have anchor points
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            Pen pen = new Pen(new SolidColorBrush(Colors.Gray), 2);
            Brush fill = Hover ? new SolidColorBrush(Colors.Red) : null;

            drawingContext.DrawEllipse(fill, pen, this.StylusPoints[0].ToPoint(), 6, 6);

        }
    }
}
