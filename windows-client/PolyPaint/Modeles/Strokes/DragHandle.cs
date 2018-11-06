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
    public class DragHandle : CustomStroke, Movable
    {

        public readonly string ParentId;

        public DragHandle(StylusPointCollection pts, CustomStrokeCollection strokes, Guid id, string parentId) : base(pts, strokes)
        {
            this.Id = id;
            this.ParentId = parentId;
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
                thisDisplayedPosition = rotationMatix.Transform(this.StylusPoints[0].ToPoint()) ;
            }
            else
                thisDisplayedPosition = this.StylusPoints[0].ToPoint();
            
            return 6 > Math.Sqrt(Math.Pow(point.X - thisDisplayedPosition.X, 2) + Math.Pow(point.Y - thisDisplayedPosition.Y, 2));
        }

        public override bool isSelectable()
        {
            return false;
        }

        public void Move(StylusPointCollection newPoints)
        {
            if (!this.strokes.has(this.ParentId)) return;

            Handleable parent = (Handleable)this.strokes.get(this.ParentId);
            parent.handleMoved(this.Id, newPoints[0].ToPoint());
        }

        public void DoneMoving()
        {
            if (!this.strokes.has(this.ParentId)) return;

            Handleable parent = (Handleable)this.strokes.get(this.ParentId);
            parent.HandleStoped(this.Id);
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            CustomStroke parent = this.strokes.get(this.ParentId);
            if (parent is ShapeStroke)
                drawingContext.PushTransform(new RotateTransform(((ShapeStroke)parent).Rotation, ((ShapeStroke)parent).Center.X, ((ShapeStroke)parent).Center.Y));

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

            if (parent is ShapeStroke)
                drawingContext.Pop();
        }
    }
}
