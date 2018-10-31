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

        public override bool HitTest(Point point)
        {
            if (!this.strokes.has(this.ParentId)) return false;

            CustomStroke parent = this.strokes.get(this.ParentId);
            Point thisDisplayedPosition;
            if (parent is ShapeStroke)
            {
                ShapeStroke shapeParent = (ShapeStroke)parent;
                Matrix rotationMatix = new Matrix();
                rotationMatix.RotateAt(shapeParent.Rotation, shapeParent.Center.X, shapeParent.Center.Y);
                thisDisplayedPosition = rotationMatix.Transform(this.StylusPoints[0].ToPoint());
            }
            else
                thisDisplayedPosition = this.StylusPoints[0].ToPoint();

            return 6 > Math.Sqrt(Math.Pow(point.X - thisDisplayedPosition.X, 2) + Math.Pow(point.Y - thisDisplayedPosition.Y, 2));
        }

        public override bool isSelectable()
        {
            return false;
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            Pen pen = new Pen(new SolidColorBrush(Colors.Gray), 2);
            Brush fill = Hover ? new SolidColorBrush(Colors.Red) : null;
            
            CustomStroke parent = this.strokes.get(this.ParentId);
            if (parent is ShapeStroke)
                drawingContext.PushTransform(new RotateTransform(((ShapeStroke)parent).Rotation, ((ShapeStroke)parent).Center.X, ((ShapeStroke)parent).Center.Y));

            drawingContext.DrawEllipse(fill, pen, this.StylusPoints[0].ToPoint(), 6, 6);
            drawingContext.Pop();

        }

        public override void Move(StylusPointCollection newPoints)
        {
            // Connot move Drag Handle
        }

        public override void handleMoved(Guid id, Point point)
        {
            // A drag handle can't have drag handles
        }
    }
}
