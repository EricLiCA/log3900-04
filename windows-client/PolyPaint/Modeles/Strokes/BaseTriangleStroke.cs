using Newtonsoft.Json;
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
    class BaseTrangleStroke : ShapeStroke
    {
        public BaseTrangleStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {

        }

        public BaseTrangleStroke(StylusPointCollection pts, CustomStrokeCollection strokes, Color color) : base(pts, strokes, color)
        {

        }

        public BaseTrangleStroke(string id, int index, StylusPointCollection pts, CustomStrokeCollection strokes, Color color) : base(id, index, pts, strokes, color)
        {

        }

        public override bool HitTest(Point point)
        {
            Point top = new Point((this.StylusPoints[0].X + this.StylusPoints[1].X) / 2, Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomRight = new Point(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));

            return PointInTriangle(point, top, bottomLeft, bottomRight);
        }

        double sign(Point p1, Point p2, Point p3)
        {
            return (p1.X - p3.X) * (p2.Y - p3.Y) - (p2.X - p3.X) * (p1.Y - p3.Y);
        }

        bool PointInTriangle(Point pt, Point v1, Point v2, Point v3)
        {
            double d1, d2, d3;
            bool has_neg, has_pos;

            d1 = sign(pt, v1, v2);
            d2 = sign(pt, v2, v3);
            d3 = sign(pt, v3, v1);

            has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
            has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);

            return !(has_neg && has_pos);
        }

        public override void addAnchorPoints()
        {
            this.deleteAnchorPoints();

            if (!this.strokes.has(this.Id.ToString())) return;

            var topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            double height = Math.Abs(this.StylusPoints[0].Y - this.StylusPoints[1].Y);
            double width = Math.Abs(this.StylusPoints[0].X - this.StylusPoints[1].X);

            int index = this.strokes.IndexOf(this.strokes.get(Id.ToString()));

            var points2 = new StylusPointCollection();
            points2.Add(new StylusPoint(topLeft.X + width / 2, topLeft.Y + height + 2));
            points2.Add(new StylusPoint(topLeft.X + width / 2, topLeft.Y + height));
            var anchor2 = new AnchorPoint(points2, this.strokes, BOTTOM, this, 1);
            this.strokes.Insert(index, anchor2);

            var points3 = new StylusPointCollection();
            points3.Add(new StylusPoint(topLeft.X + width / 4 - 2, topLeft.Y + height / 2));
            points3.Add(new StylusPoint(topLeft.X + width / 4, topLeft.Y + height / 2));
            var anchor3 = new AnchorPoint(points3, this.strokes, LEFT, this, 2);
            this.strokes.Insert(index, anchor3);

            var points4 = new StylusPointCollection();
            points4.Add(new StylusPoint(topLeft.X + 3 * width / 4 + 2, topLeft.Y + height / 2));
            points4.Add(new StylusPoint(topLeft.X + 3 * width / 4, topLeft.Y + height / 2));
            var anchor4 = new AnchorPoint(points4, this.strokes, RIGHT, this, 0);
            this.strokes.Insert(index, anchor4);


        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {

            DrawingAttributes originalDa = drawingAttributes.Clone();
            SolidColorBrush fillBrush = (this is Textable) ? new SolidColorBrush(Colors.White) : new SolidColorBrush(this.Color);
            fillBrush.Freeze();
            Pen outlinePen = new Pen(new SolidColorBrush(Colors.Black), 1);

            Point top = new Point((this.StylusPoints[0].X + this.StylusPoints[1].X) / 2, Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomRight = new Point(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            Point bottomLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y));

            drawingContext.PushTransform(new RotateTransform(Rotation, Center.X, Center.Y));

            var segments = new[]
           {
              new LineSegment(bottomRight, true),
              new LineSegment(bottomLeft, true)
           };

            var figure = new PathFigure(top, segments, true);
            var geo = new PathGeometry(new[] { figure });

            if (this.isSelected())
            {
                Pen selectedPen = new Pen(new SolidColorBrush(Colors.GreenYellow), 5);
                selectedPen.Freeze();
                drawingContext.DrawGeometry(fillBrush, selectedPen, geo);
            }

            if (this.AnchorPointVisibility)
            {
                this.addAnchorPoints();
            }

            drawingContext.DrawGeometry(fillBrush, outlinePen, geo);

            if (this.isEditing())
            {
                this.addDragHandles();
            }

            drawingContext.Pop();
        }

        public override Point getAnchorPointPosition(int index)
        {
            var topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            double height = Math.Abs(this.StylusPoints[0].Y - this.StylusPoints[1].Y);
            double width = Math.Abs(this.StylusPoints[0].X - this.StylusPoints[1].X);

            Point localPosition;
            switch (index)
            {
                case 0:
                    localPosition = new Point(topLeft.X + 3 * width / 4, topLeft.Y + height / 2);
                    break;
                case 1:
                    localPosition = new Point(topLeft.X + width / 2, topLeft.Y + height);
                    break;
                default:
                    localPosition = new Point(topLeft.X + width / 4, topLeft.Y + height / 2);
                    break;
            }

            Matrix shader = new Matrix();
            shader.RotateAt(Rotation, Center.X, Center.Y);
            return shader.Transform(localPosition);

        }

        public override StrokeType StrokeType() => Strokes.StrokeType.TRIANGLE;
    }
}
