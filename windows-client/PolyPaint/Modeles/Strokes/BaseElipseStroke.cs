using Newtonsoft.Json;
using System;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Strokes
{

    class BaseElipseStroke : ShapeStroke
    {
        public BaseElipseStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {

        }

        public BaseElipseStroke(StylusPointCollection pts, CustomStrokeCollection strokes, Color color) : base(pts, strokes, color)
        {

        }

        public BaseElipseStroke(string id, StylusPointCollection pts, CustomStrokeCollection strokes, Color color) : base(id, pts, strokes, color)
        {

        }

        public override bool HitTest(Point point)
        {
            Matrix antiRotationMatix = new Matrix();
            antiRotationMatix.RotateAt(-Rotation, Center.X, Center.Y);
            Point clickedLocal = antiRotationMatix.Transform(point);

            double width = Math.Abs(this.StylusPoints[0].X - this.StylusPoints[1].X);
            double height = Math.Abs(this.StylusPoints[0].Y - this.StylusPoints[1].Y);
            double centerX = (this.StylusPoints[0].X + this.StylusPoints[1].X) / 2;
            double centerY = (this.StylusPoints[0].Y + this.StylusPoints[1].Y) / 2;
            return Math.Pow(clickedLocal.X - centerX, 2) / Math.Pow(width / 2, 2) + Math.Pow(clickedLocal.Y - centerY, 2) / Math.Pow(height / 2, 2) <= 1;
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            drawingContext.PushTransform(new RotateTransform(Rotation, Center.X, Center.Y));
            
            DrawingAttributes originalDa = drawingAttributes.Clone();
            SolidColorBrush fillBrush = (this is Textable) ? new SolidColorBrush(Colors.White) : new SolidColorBrush(this.Color);
            fillBrush.Freeze();
            Pen outlinePen = new Pen(new SolidColorBrush(Colors.Black), 1);
            outlinePen.Freeze();

            StylusPoint stp = this.StylusPoints[0];
            StylusPoint sp = this.StylusPoints[1];
            
            if (this.isSelected())
            {
                Pen selectedPen = new Pen(new SolidColorBrush(Colors.GreenYellow), 5);
                selectedPen.Freeze();
                drawingContext.DrawEllipse(null, selectedPen, new Point((sp.X + stp.X) / 2.0, (sp.Y + stp.Y) / 2.0), Math.Abs(sp.X - stp.X) / 2, Math.Abs(sp.Y - stp.Y) / 2);
            }

            if (this.AnchorPointVisibility)
            {
                this.addAnchorPoints();
            }
            drawingContext.DrawEllipse(fillBrush, outlinePen, new Point((sp.X + stp.X) / 2.0, (sp.Y + stp.Y) / 2.0), Math.Abs(sp.X - stp.X) / 2, Math.Abs(sp.Y - stp.Y) / 2);
            

            if (this.isEditing())
            {
                this.addDragHandles();
            }

            drawingContext.Pop();
        }

        public override StrokeType StrokeType() => Strokes.StrokeType.ELIPSE;
    }
}
