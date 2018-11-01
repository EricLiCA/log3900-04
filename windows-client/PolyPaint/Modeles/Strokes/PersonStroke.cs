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
    class PersonStroke : ShapeStroke
    {
        private string Name;

        public PersonStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {
        }

        public PersonStroke(StylusPointCollection pts, CustomStrokeCollection strokes, string name) : base(pts, strokes)
        {
            this.Name = name;
        }

        public override bool HitTest(Point point)
        {
            Matrix antiRotationMatix = new Matrix();
            antiRotationMatix.RotateAt(-Rotation, Center.X, Center.Y);
            Point clickedLocal = antiRotationMatix.Transform(point);

            Point topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomRight = new Point(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));

            return clickedLocal.X > topLeft.X && clickedLocal.X < bottomRight.X && clickedLocal.Y > topLeft.Y && clickedLocal.Y < bottomRight.Y;
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            DrawingAttributes originalDa = drawingAttributes.Clone();
            SolidColorBrush fillBrush = new SolidColorBrush(drawingAttributes.Color);
            Pen outlinePen = new Pen(new SolidColorBrush(Colors.Black), 2);

            double height = Math.Abs(this.StylusPoints[0].Y - this.StylusPoints[1].Y);
            double width = Math.Abs(this.StylusPoints[0].X - this.StylusPoints[1].X);
            Point TOP_LEFT = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));


            Point headPos = TOP_LEFT;
            headPos.X += width / 2;
            headPos.Y += height / 7;

            Point neck = headPos;
            neck.Y += height / 7;
            Point crouch = neck;
            crouch.Y += height * 2.5 / 7;
            
            Point leftArm = TOP_LEFT;
            leftArm.Y += height * 3 / 7;
            Point rightArm = leftArm;
            rightArm.X += width;

            Point leftFoot = TOP_LEFT;
            leftFoot.Y += height;
            Point rightFoot = leftFoot;
            rightFoot.X += width;


            drawingContext.PushTransform(new RotateTransform(Rotation, Center.X, Center.Y));

            if (this.isSelected())
            {
                Pen selectedPen = new Pen(new SolidColorBrush(Colors.GreenYellow), 10);
                drawingContext.DrawEllipse(new SolidColorBrush(Colors.White), selectedPen, headPos, width / 2.5, height / 7);
                drawingContext.DrawLine(selectedPen, neck, crouch);
                drawingContext.DrawLine(selectedPen, rightArm, leftArm);
                drawingContext.DrawLine(selectedPen, crouch, rightFoot);
                drawingContext.DrawLine(selectedPen, crouch, leftFoot);
            }
            
            if (this.AnchorPointVisibility)
            {
                this.addAnchorPoints();
            }

            drawingContext.DrawEllipse(new SolidColorBrush(Colors.White), outlinePen, headPos, width / 2.5, height / 7);
            drawingContext.DrawLine(outlinePen, neck, crouch);
            drawingContext.DrawLine(outlinePen, rightArm, leftArm);
            drawingContext.DrawLine(outlinePen, crouch, rightFoot);
            drawingContext.DrawLine(outlinePen, crouch, leftFoot);

            drawingContext.Pop();

            if (this.isEditing())
            {
                this.addDragHandles();
            }

        }
    }
}
