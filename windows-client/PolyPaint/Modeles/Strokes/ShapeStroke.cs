using Newtonsoft.Json;
using PolyPaint.Services;
using System;
using System.Linq;
using System.Windows;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Strokes
{
     public abstract class ShapeStroke : CustomStroke, Anchorable, Handleable, Movable, Savable
    {
        private double _rotation = 0;
        public double Rotation {
            get => _rotation;
            set
            {
                _rotation = value % 360;
                _rotation -= value % 10;
                this.Refresh();
                this.strokes.ToList().FindAll(stroke => stroke is BaseLine).ForEach(stroke => ((BaseLine)stroke).anchorableMoved(this));
            }
        }

        public Point Center
        {
            get => new Point((StylusPoints[0].X + StylusPoints[1].X) / 2, (StylusPoints[0].Y + StylusPoints[1].Y) / 2);
        }

        public double Width
        {
            get => Math.Abs(StylusPoints[0].X - StylusPoints[1].X);
        }

        public double Height
        {
            get => Math.Abs(StylusPoints[0].Y - StylusPoints[1].Y);
        }

        protected Guid TOP_LEFT = Guid.NewGuid();
        protected Guid BOTTOM_LEFT = Guid.NewGuid();
        protected Guid TOP_RIGHT = Guid.NewGuid();
        protected Guid BOTTOM_RIGHT = Guid.NewGuid();

        protected Guid TOP = Guid.NewGuid();
        protected Guid BOTTOM = Guid.NewGuid();
        protected Guid LEFT = Guid.NewGuid();
        protected Guid RIGHT = Guid.NewGuid();

        protected bool AnchorPointVisibility = false;

        public ShapeStroke(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {
        }

        public void addDragHandles()
        {
            if (!this.strokes.has(this.Id.ToString())) return;
            this.deleteDragHandles();

            var pointsTopLeft = new StylusPointCollection();
            pointsTopLeft.Add(new StylusPoint(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X) - 4, Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y) - 4));
            pointsTopLeft.Add(new StylusPoint(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y)));
            this.strokes.Add(new DragHandle(pointsTopLeft, this.strokes, TOP_LEFT, this.Id.ToString()));

            var pointsTopRight = new StylusPointCollection();
            pointsTopRight.Add(new StylusPoint(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X) - 4, Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y) + 4));
            pointsTopRight.Add(new StylusPoint(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y)));
            this.strokes.Add(new DragHandle(pointsTopRight, this.strokes, BOTTOM_LEFT, this.Id.ToString()));

            var pointsBottomLeft = new StylusPointCollection();
            pointsBottomLeft.Add(new StylusPoint(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X) + 4, Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y) - 4));
            pointsBottomLeft.Add(new StylusPoint(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y)));
            this.strokes.Add(new DragHandle(pointsBottomLeft, this.strokes, TOP_RIGHT, this.Id.ToString()));

            var pointsBottomRight = new StylusPointCollection();
            pointsBottomRight.Add(new StylusPoint(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X) + 4, Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y) + 4));
            pointsBottomRight.Add(new StylusPoint(Math.Max(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Max(this.StylusPoints[0].Y, this.StylusPoints[1].Y)));
            this.strokes.Add(new DragHandle(pointsBottomRight, this.strokes, BOTTOM_RIGHT, this.Id.ToString()));

        }

        public void deleteDragHandles()
        {
            if (this.strokes.has(TOP_LEFT.ToString()))
                this.strokes.Remove(this.strokes.get(TOP_LEFT.ToString()));
            if (this.strokes.has(BOTTOM_LEFT.ToString()))
                this.strokes.Remove(this.strokes.get(BOTTOM_LEFT.ToString()));
            if (this.strokes.has(TOP_RIGHT.ToString()))
                this.strokes.Remove(this.strokes.get(TOP_RIGHT.ToString()));
            if (this.strokes.has(BOTTOM_RIGHT.ToString()))
                this.strokes.Remove(this.strokes.get(BOTTOM_RIGHT.ToString()));
        }

        public virtual void addAnchorPoints()
        {
            this.deleteAnchorPoints();

            if (!this.strokes.has(this.Id.ToString())) return;

            var topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            double height = Math.Abs(this.StylusPoints[0].Y - this.StylusPoints[1].Y);
            double width = Math.Abs(this.StylusPoints[0].X - this.StylusPoints[1].X);
            
            int index = this.strokes.IndexOf(this.strokes.get(Id.ToString()));
            
            var points1 = new StylusPointCollection();
            points1.Add(new StylusPoint(topLeft.X + width / 2, topLeft.Y - 2));
            points1.Add(new StylusPoint(topLeft.X + width / 2, topLeft.Y));
            var anchor1 = new AnchorPoint(points1, this.strokes, TOP, this, 3);
            this.strokes.Insert(index, anchor1);
            
            var points2 = new StylusPointCollection();
            points2.Add(new StylusPoint(topLeft.X + width / 2, topLeft.Y + height + 2));
            points2.Add(new StylusPoint(topLeft.X + width / 2, topLeft.Y + height));
            var anchor2 = new AnchorPoint(points2, this.strokes, BOTTOM, this, 1);
            this.strokes.Insert(index, anchor2);
            
            var points3 = new StylusPointCollection();
            points3.Add(new StylusPoint(topLeft.X - 2, topLeft.Y + height / 2));
            points3.Add(new StylusPoint(topLeft.X, topLeft.Y + height / 2));
            var anchor3 = new AnchorPoint(points3, this.strokes, LEFT, this, 2);
            this.strokes.Insert(index, anchor3);
            
            var points4 = new StylusPointCollection();
            points4.Add(new StylusPoint(topLeft.X + width + 2, topLeft.Y + height / 2));
            points4.Add(new StylusPoint(topLeft.X + width, topLeft.Y + height / 2));
            var anchor4 = new AnchorPoint(points4, this.strokes, RIGHT, this, 0);
            this.strokes.Insert(index, anchor4);
            

        }

        public void deleteAnchorPoints()
        {
            if (this.strokes.has(TOP.ToString()))
                this.strokes.Remove(this.strokes.get(TOP.ToString()));
            if (this.strokes.has(BOTTOM.ToString()))
                this.strokes.Remove(this.strokes.get(BOTTOM.ToString()));
            if (this.strokes.has(LEFT.ToString()))
                this.strokes.Remove(this.strokes.get(LEFT.ToString()));
            if (this.strokes.has(RIGHT.ToString()))
                this.strokes.Remove(this.strokes.get(RIGHT.ToString()));
        }

        public void showAnchorPoints()
        {
            this.AnchorPointVisibility = true;
            this.Refresh();
        }

        public void hideAnchorPoints()
        {
            this.AnchorPointVisibility = false;
            this.Refresh();
        }

        public void Move(StylusPointCollection newPoints)
        {
            this.StylusPoints = newPoints;
            this.Refresh();
            this.strokes.ToList().FindAll(stroke => stroke is BaseLine).ForEach(stroke => ((BaseLine)stroke).anchorableMoved(this));
        }

        public void handleMoved(Guid id, Point point)
        {
            Point oppo;
            if (id.ToString() == TOP_RIGHT.ToString())
            {
                oppo = this.strokes.get(BOTTOM_LEFT.ToString()).StylusPoints[1].ToPoint();
            }
            else if (id.ToString() == TOP_LEFT.ToString())
            {
                oppo = this.strokes.get(BOTTOM_RIGHT.ToString()).StylusPoints[1].ToPoint();
            }
            else if (id.ToString() == BOTTOM_LEFT.ToString())
            {
                oppo = this.strokes.get(TOP_RIGHT.ToString()).StylusPoints[1].ToPoint();
            }
            else
            {
                oppo = this.strokes.get(TOP_LEFT.ToString()).StylusPoints[1].ToPoint();
            }

            Matrix shader = new Matrix();
            shader.RotateAt(Rotation, Center.X, Center.Y);

            Point invariable = shader.Transform(oppo);
            
            Matrix antiShader = new Matrix();
            antiShader.RotateAt(-Rotation, (invariable.X + point.X) / 2, (invariable.Y + point.Y) / 2);

            Point localCoordinate1 = antiShader.Transform(invariable);
            Point localCoordinate2 = antiShader.Transform(point);

            StylusPointCollection newPoints = new StylusPointCollection();
            newPoints.Add(new StylusPoint(localCoordinate1.X, localCoordinate1.Y));
            newPoints.Add(new StylusPoint(localCoordinate2.X, localCoordinate2.Y));

            this.StylusPoints = newPoints;
            this.Refresh();
            this.strokes.ToList().FindAll(stroke => stroke is BaseLine).ForEach(stroke => ((BaseLine)stroke).anchorableMoved(this));
        }

        public override void Refresh()
        {
            if (strokes.has(this.Id.ToString()))
                ((ShapeStroke)strokes.get(this.Id.ToString())).deleteAnchorPoints();
            
            base.Refresh();
        }

        public override bool isSelectable()
        {
            return true;
        }

        public bool isOnAnchorPoint(int index, Point point)
        {
            string anchorId = null;
            switch (index)
            {
                case 0:
                    anchorId = RIGHT.ToString();
                    break;
                case 1:
                    anchorId = BOTTOM.ToString();
                    break;
                case 2:
                    anchorId = LEFT.ToString();
                    break;
                case 3:
                    anchorId = TOP.ToString();
                    break;
            }

            if (anchorId == null || !this.strokes.has(anchorId)) return false;

            return ((AnchorPoint)this.strokes.get(anchorId)).HitTest(point);
        }

        public virtual Point getAnchorPointPosition(int index)
        {
            var topLeft = new Point(Math.Min(this.StylusPoints[0].X, this.StylusPoints[1].X), Math.Min(this.StylusPoints[0].Y, this.StylusPoints[1].Y));
            double height = Math.Abs(this.StylusPoints[0].Y - this.StylusPoints[1].Y);
            double width = Math.Abs(this.StylusPoints[0].X - this.StylusPoints[1].X);

            Point localPosition;
            switch (index)
            {
                case 0:
                    localPosition = new Point(topLeft.X + width, topLeft.Y + height / 2);
                    break;
                case 1:
                    localPosition = new Point(topLeft.X + width / 2, topLeft.Y + height);
                    break;
                case 2:
                    localPosition = new Point(topLeft.X, topLeft.Y + height / 2);
                    break;
                default:
                    localPosition = new Point(topLeft.X + width / 2, topLeft.Y);
                    break;
            }

            Matrix shader = new Matrix();
            shader.RotateAt(Rotation, Center.X, Center.Y);
            return shader.Transform(localPosition);

        }

        public override void RefreshGuids()
        {
            Id = Guid.NewGuid();
            TOP_LEFT = Guid.NewGuid();
            BOTTOM_LEFT = Guid.NewGuid();
            TOP_RIGHT = Guid.NewGuid();
            BOTTOM_RIGHT = Guid.NewGuid();
            TOP = Guid.NewGuid();
            BOTTOM = Guid.NewGuid();
            LEFT = Guid.NewGuid();
            RIGHT = Guid.NewGuid();
        }

        public void DoneMoving()
        {
            //Send Modifications to server
        }

        public void HandleStoped(Guid id)
        {
            //Send Modifications to server
        }

        public virtual string toJson()
        {
            SerializedStroke toSend = new SerializedStroke()
            {
                Id = this.Id,
                ShapeType = this.StrokeType().ToString(),
                Index = -1,
                ShapeInfo = JsonConvert.SerializeObject(GetShapeInfo()),
                ImageId = ServerService.instance.currentImageId
            };
            return JsonConvert.SerializeObject(toSend);
        }

        public abstract StrokeType StrokeType();
        public virtual ShapeInfo GetShapeInfo()
        {
            return new ShapeInfo
            {
                Center = new ShapePoint() { X = this.Center.X, Y = this.Center.Y },
                Height = this.Height,
                Width = this.Width,
                Color = new ColorConverter().ConvertToString(this.DrawingAttributes.Color)
            };
        }
    }
}
