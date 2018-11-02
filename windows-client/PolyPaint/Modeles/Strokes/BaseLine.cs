using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Strokes
{
    class BaseLine : CustomStroke, Handleable
    {
        Guid FIRST_POINT = Guid.NewGuid();
        Guid SECOND_POINT = Guid.NewGuid();

        string FirstAnchorId;
        string SecondAncorId;
        int FirstAnchorIndex;
        int SecondAncorIndex;

        public BaseLine(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {
        }

        public BaseLine(StylusPointCollection pts, CustomStrokeCollection strokes,
                        string firstAnchorId, int firstAnchorIndex,
                        string secondAnchorId, int secondAnchorIndex) : base(pts, strokes)
        {
            if (firstAnchorId != null)
            {
                this.FirstAnchorId = firstAnchorId;
                this.FirstAnchorIndex = firstAnchorIndex;
            }
            if (secondAnchorId != null)
            {
                this.SecondAncorId = secondAnchorId;
                this.SecondAncorIndex = secondAnchorIndex;
            }
        }

        public void addDragHandles()
        {
            if (!this.strokes.has(this.Id.ToString())) return;
            this.deleteDragHandles();

            var pointsFirst = new StylusPointCollection();
            pointsFirst.Add(new StylusPoint(this.StylusPoints[0].X, this.StylusPoints[0].Y));
            this.strokes.Add(new DragHandle(pointsFirst, this.strokes, FIRST_POINT, this.Id.ToString()));
            
            var pointsSecond = new StylusPointCollection();
            pointsSecond.Add(new StylusPoint( this.StylusPoints[1].X, this.StylusPoints[1].Y));
            this.strokes.Add(new DragHandle(pointsSecond, this.strokes, SECOND_POINT, this.Id.ToString()));

        }

        public void deleteDragHandles()
        {
            if (this.strokes.has(FIRST_POINT.ToString()))
                this.strokes.Remove(this.strokes.get(FIRST_POINT.ToString()));
            if (this.strokes.has(SECOND_POINT.ToString()))
                this.strokes.Remove(this.strokes.get(SECOND_POINT.ToString()));
        }

        public override bool HitTest(Point point)
        {
            return 10 > FindDistanceToSegment(point, this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint());
        }

        private double FindDistanceToSegment( Point pt, Point p1, Point p2)
        {
            double dx = p2.X - p1.X;
            double dy = p2.Y - p1.Y;
            if ((dx == 0) && (dy == 0))
            {
                // It's a point not a line segment.
                dx = pt.X - p1.X;
                dy = pt.Y - p1.Y;
                return Math.Sqrt(dx * dx + dy * dy);
            }

            // Calculate the t that minimizes the distance.
            double t = ((pt.X - p1.X) * dx + (pt.Y - p1.Y) * dy) /
                (dx * dx + dy * dy);

            // See if this represents one of the segment's
            // end points or a point in the middle.
            if (t < 0)
            {
                Point closest = new Point(p1.X, p1.Y);
                dx = pt.X - p1.X;
                dy = pt.Y - p1.Y;
            }
            else if (t > 1)
            {
                Point closest = new Point(p2.X, p2.Y);
                dx = pt.X - p2.X;
                dy = pt.Y - p2.Y;
            }
            else
            {
                Point closest = new Point(p1.X + t * dx, p1.Y + t * dy);
                dx = pt.X - closest.X;
                dy = pt.Y - closest.Y;
            }

            return Math.Sqrt(dx * dx + dy * dy);
        }

        public override bool isSelectable()
        {
            return true;
        }

        public void handleMoved(Guid id, Point point)
        {
            AnchorPoint anchor = null;
            string hoverId = null;
            int hoverIndex = -1;
            List<Stroke> hoveredAnchors = strokes.ToList().FindAll(stroke => stroke is AnchorPoint && ((CustomStroke)stroke).HitTest(point));
            if (hoveredAnchors.Count > 0)
            {
                anchor = (AnchorPoint)hoveredAnchors.Last();
                point = anchor.Parent.getAnchorPointPosition(anchor.AnchorIndex);
                hoverId = anchor.ParentId;
                hoverIndex = anchor.AnchorIndex;
            }

            if (this.FIRST_POINT.ToString() == id.ToString())
            {
                this.FirstAnchorId = hoverId;
                this.FirstAnchorIndex = hoverIndex;
                if (hoverId == null || anchor == null)
                    this.StylusPoints[0] = new StylusPoint(point.X, point.Y);
                else
                {
                    Point clip = anchor.Parent.getAnchorPointPosition(hoverIndex);
                    this.StylusPoints[0] = new StylusPoint(clip.X, clip.Y);
                }

                this.Refresh();
            }
            else if (this.SECOND_POINT.ToString() == id.ToString())
            {
                this.SecondAncorId = hoverId;
                this.SecondAncorIndex = hoverIndex;
                if (hoverId == null || anchor == null)
                    this.StylusPoints[1] = new StylusPoint(point.X, point.Y);
                else
                {
                    Point clip = anchor.Parent.getAnchorPointPosition(hoverIndex);
                    this.StylusPoints[1] = new StylusPoint(clip.X, clip.Y);
                }

                this.Refresh();
            }
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            DrawingAttributes originalDa = drawingAttributes.Clone();
            Pen outlinePen = new Pen(new SolidColorBrush(Colors.Black), 2);

            if (this.isSelected())
            {
                Pen selectedPen = new Pen(new SolidColorBrush(Colors.GreenYellow), 10);
                selectedPen.Freeze();
                drawingContext.DrawLine(selectedPen, this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint());
            }

            drawingContext.DrawLine(outlinePen, this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint());

            if (this.isEditing())
            {
                this.addDragHandles();
            }
        }

        internal void anchorableMoved(Anchorable anchorable)
        {
            bool changed = false;
            if (((CustomStroke)anchorable).Id.ToString() == this.FirstAnchorId)
            {
                Point newPoint = anchorable.getAnchorPointPosition(this.FirstAnchorIndex);
                this.StylusPoints[0] = new StylusPoint(newPoint.X, newPoint.Y);
                changed = true;
            }

            if (((CustomStroke)anchorable).Id.ToString() == this.SecondAncorId)
            {
                Point newPoint = anchorable.getAnchorPointPosition(this.SecondAncorIndex);
                this.StylusPoints[1] = new StylusPoint(newPoint.X, newPoint.Y);
                changed = true;
            }

            if (changed) this.Refresh();
        }

        public override void RefreshGuids()
        {
            Id = Guid.NewGuid();
            FIRST_POINT = Guid.NewGuid();
            SECOND_POINT = Guid.NewGuid();
        }
    }
}
