﻿using Newtonsoft.Json;
using PolyPaint.Services;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Strokes
{
    class BaseLine : CustomStroke, Handleable, Savable
    {
        List<Guid> HandlePoints;

        public string FirstAnchorId;
        public string SecondAncorId;
        public int FirstAnchorIndex;
        public int SecondAncorIndex;

        public Relation FirstRelation = Relation.ASSOCIATION;
        public Relation SecondRelation = Relation.ASSOCIATION;
        public string FirstText = "";
        public string SecondText = "";

        public BaseLine(StylusPointCollection pts, CustomStrokeCollection strokes) : base(pts, strokes)
        {
            this.HandlePoints = new List<Guid>();
            for (int i = 0; i < pts.Count; i++)
                this.HandlePoints.Add(Guid.NewGuid());
        }

        public BaseLine(string id, int index, StylusPointCollection pts, CustomStrokeCollection strokes) : base(id, index, pts, strokes)
        {
            this.HandlePoints = new List<Guid>();
            for (int i = 0; i < pts.Count; i++)
                this.HandlePoints.Add(Guid.NewGuid());
        }

        public BaseLine(StylusPointCollection pts, CustomStrokeCollection strokes,
                        string firstAnchorId, int firstAnchorIndex,
                        string secondAnchorId, int secondAnchorIndex) : this(pts, strokes)
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

        public BaseLine(string id, int index, StylusPointCollection pts, CustomStrokeCollection strokes,
                        string firstAnchorId, int firstAnchorIndex,
                        string secondAnchorId, int secondAnchorIndex,
                        string firstLabel, string secondLabel,
                        string firstRelation, string secondRelation) : this(id, index, pts, strokes)
        {
            this.FirstText = firstLabel;
            this.SecondText = secondLabel;
            this.FirstRelation = this.GetRelationByName(firstRelation);
            this.SecondRelation = this.GetRelationByName(secondRelation);

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

        private Relation GetRelationByName(String name)
        {
            switch (name)
            {
                case "AGGREGATION":
                    return Relation.AGGREGATION;
                case "ASSOCIATION":
                    return Relation.ASSOCIATION;
                case "COMPOSITION":
                    return Relation.COMPOSITION;
                case "INHERITANCE":
                    return Relation.INHERITANCE;
            }
            return Relation.ASSOCIATION;
        }

        public void addDragHandles()
        {
            if (!this.strokes.has(this.Id.ToString())) return;
            this.deleteDragHandles();

            for (int i = 0; i < this.HandlePoints.Count; i++)
            {
                var positions = new StylusPointCollection();
                positions.Add(new StylusPoint(this.StylusPoints[i].X, this.StylusPoints[i].Y));
                this.strokes.Add(new DragHandle(positions, this.Index, this.strokes, this.HandlePoints[i], this.Id.ToString()));
            }
        }

        internal string getFirstLabel()
        {
            return this.FirstText;
        }

        internal void setFirstLabel(string value)
        {
            this.FirstText = value;
            this.Refresh();
            EditionSocket.EditStroke(this.toJson());
        }

        internal string getSecondLabel()
        {
            return this.SecondText;
        }

        internal void setSecondLabel(string value)
        {
            this.SecondText = value;
            this.Refresh();
            EditionSocket.EditStroke(this.toJson());
        }

        internal Relation getFirstRelation()
        {
            return this.FirstRelation;
        }

        internal void setFirstRelation(Relation value)
        {
            this.FirstRelation = value;
            this.Refresh();
            EditionSocket.EditStroke(this.toJson());
        }

        internal Relation getSecondRelation()
        {
            return this.SecondRelation;
        }

        internal void setSecondRelation(Relation value)
        {
            this.SecondRelation = value;
            this.Refresh();
            EditionSocket.EditStroke(this.toJson());
        }

        public void deleteDragHandles()
        {
            for (int i = 0; i < this.HandlePoints.Count; i++)
            {
                if (this.strokes.has(this.HandlePoints[i].ToString()))
                    this.strokes.Remove(this.strokes.get(this.HandlePoints[i].ToString()));
            }
        }

        internal void newPoint(Point point)
        {
            int clickedLine = this.ClickedLine(point);
            this.StylusPoints.Insert(clickedLine + 1, new StylusPoint(point.X, point.Y));
            this.HandlePoints.Insert(clickedLine + 1, Guid.NewGuid());
            this.Refresh();
        }

        public override bool HitTest(Point point)
        {
            return this.ClickedLine(point) > -1;
        }

        public int ClickedLine(Point point)
        {
            for (int i = 0; i < this.StylusPoints.Count - 1; i++)
                if (10 > FindDistanceToSegment(point, this.StylusPoints[i].ToPoint(), this.StylusPoints[i + 1].ToPoint()))
                    return i;
            
            return -1;
        }

        private double FindDistanceToSegment( Point pt, Point p1, Point p2)
        {
            double dx = p2.X - p1.X;
            double dy = p2.Y - p1.Y;
            if ((dx == 0) && (dy == 0))
            {
                dx = pt.X - p1.X;
                dy = pt.Y - p1.Y;
                return Math.Sqrt(dx * dx + dy * dy);
            }
            
            double t = ((pt.X - p1.X) * dx + (pt.Y - p1.Y) * dy) /
                (dx * dx + dy * dy);
            
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

        private double FindAngle(Point p1, Point p2)
        {
            double angle = Math.Atan((p2.Y - p1.Y) / (p2.X - p1.X));
            if (p1.X > p2.X)
                angle += Math.PI;
            if (angle < 0)
                angle += 2 * Math.PI;
            return angle;
        }

        public override bool isSelectable()
        {
            return true;
        }

        public void handleMoved(Guid id, Point point)
        {
            int movedIndex = this.HandlePoints.FindIndex(i => i.ToString() == id.ToString());
            
            if (movedIndex == 0 || movedIndex == this.HandlePoints.Count - 1) {
                List<Stroke> hoveredAnchors = strokes.ToList().FindAll(stroke => stroke is AnchorPoint && ((CustomStroke)stroke).HitTest(point));
                if (hoveredAnchors.Count > 0)
                {
                    AnchorPoint anchor = (AnchorPoint)hoveredAnchors.Last();
                    point = anchor.Parent.getAnchorPointPosition(anchor.AnchorIndex);

                    if (movedIndex == 0)
                    {
                        this.FirstAnchorId = anchor.ParentId;
                        this.FirstAnchorIndex = anchor.AnchorIndex;
                    }
                    else
                    {
                        this.SecondAncorId = anchor.ParentId;
                        this.SecondAncorIndex = anchor.AnchorIndex;
                    }
                }
                else
                {
                    if (movedIndex == 0)
                        this.FirstAnchorId = null;
                    else
                        this.SecondAncorId = null;
                }
            }

            this.StylusPoints[movedIndex] = new StylusPoint(point.X, point.Y);
            this.Refresh();
        }

        public void HandleStoped(Guid id)
        {
            int movedIndex = this.HandlePoints.FindIndex(i => i.ToString() == id.ToString());
            if (!(movedIndex == 0 || movedIndex == this.HandlePoints.Count - 1))
                if (10 > this.FindDistanceToSegment(this.StylusPoints[movedIndex].ToPoint(), this.StylusPoints[movedIndex - 1].ToPoint(), this.StylusPoints[movedIndex + 1].ToPoint()))
                {
                    this.deleteDragHandles();
                    this.HandlePoints.RemoveAt(movedIndex);
                    this.StylusPoints.RemoveAt(movedIndex);
                    this.Refresh();
                }

            EditionSocket.EditStroke(this.toJson());
        }

        protected override void DrawCore(DrawingContext drawingContext, DrawingAttributes drawingAttributes)
        {
            DrawingAttributes originalDa = drawingAttributes.Clone();
            Pen outlinePen = new Pen(new SolidColorBrush(Colors.Black), 1);

            if (this.isSelected() || this.isLocked())
            {
                Pen selectedPen = new Pen(new SolidColorBrush(this.isSelected() ? Colors.GreenYellow : Colors.OrangeRed), 5);
                selectedPen.Freeze();
                for (int i = 0; i < this.StylusPoints.Count - 1; i++)
                    drawingContext.DrawLine(selectedPen, this.StylusPoints[i].ToPoint(), this.StylusPoints[i + 1].ToPoint());
            }

            for (int i = 0; i < this.StylusPoints.Count - 1; i++)
                drawingContext.DrawLine(outlinePen, this.StylusPoints[i].ToPoint(), this.StylusPoints[i + 1].ToPoint());

            if (this.isEditing())
            {
                this.addDragHandles();
            }

            FormattedText firstLabel = new FormattedText(this.FirstText, CultureInfo.CurrentCulture, FlowDirection.LeftToRight, new Typeface("Verdana"), 12, Brushes.Black);
            drawingContext.DrawText(firstLabel, this.GetLabelPosition(this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint(), firstLabel.Width, true));
            
            FormattedText secondLabel = new FormattedText(this.SecondText, CultureInfo.CurrentCulture, FlowDirection.LeftToRight, new Typeface("Verdana"), 12, Brushes.Black);
            drawingContext.DrawText(secondLabel, this.GetLabelPosition(this.StylusPoints[this.StylusPoints.Count - 1].ToPoint(), this.StylusPoints[this.StylusPoints.Count - 2].ToPoint(), secondLabel.Width, false));

            double symbolSize = 6;
            double firstAngle = this.FindAngle(this.StylusPoints[0].ToPoint(), this.StylusPoints[1].ToPoint());
            Point firstRelationPosition = new Point(
                this.StylusPoints[0].X + Math.Cos(firstAngle) * Math.Sqrt(Math.Pow(symbolSize, 2) * 2),
                this.StylusPoints[0].Y + Math.Sin(firstAngle) * Math.Sqrt(Math.Pow(symbolSize, 2) * 2));
            drawingContext.PushTransform(new RotateTransform((firstAngle + Math.PI / 4) / Math.PI * 180, firstRelationPosition.X, firstRelationPosition.Y));

            if (this.FirstRelation == Relation.AGGREGATION)
                drawingContext.DrawRectangle(new SolidColorBrush(Colors.White), outlinePen, new Rect(firstRelationPosition.X - symbolSize, firstRelationPosition.Y - symbolSize, symbolSize * 2 , symbolSize * 2));

            if (this.FirstRelation == Relation.COMPOSITION)
                drawingContext.DrawRectangle(new SolidColorBrush(Colors.Black), outlinePen, new Rect(firstRelationPosition.X - symbolSize, firstRelationPosition.Y - symbolSize, symbolSize * 2, symbolSize * 2));

            if (this.FirstRelation == Relation.INHERITANCE)
            {

                var segments = new[]
                {
                   new LineSegment(new Point(
                       firstRelationPosition.X - symbolSize,
                       firstRelationPosition.Y - symbolSize), true),
                   new LineSegment(new Point(
                       firstRelationPosition.X - symbolSize,
                       firstRelationPosition.Y + symbolSize), true)
                };

                var figure = new PathFigure(new Point(
                       firstRelationPosition.X + symbolSize,
                       firstRelationPosition.Y + symbolSize), segments, true);
                var geo = new PathGeometry(new[] { figure });
                drawingContext.DrawGeometry(new SolidColorBrush(Colors.White), outlinePen, geo);
            }

            drawingContext.Pop();

            double secondAngle = this.FindAngle(this.StylusPoints[this.StylusPoints.Count - 1].ToPoint(), this.StylusPoints[this.StylusPoints.Count - 2].ToPoint());
            Point secondRelationPosition = new Point(
                this.StylusPoints[this.StylusPoints.Count - 1].X + Math.Cos(secondAngle) * Math.Sqrt(Math.Pow(symbolSize, 2) * 2),
                this.StylusPoints[this.StylusPoints.Count - 1].Y + Math.Sin(secondAngle) * Math.Sqrt(Math.Pow(symbolSize, 2) * 2));
            drawingContext.PushTransform(new RotateTransform((secondAngle + Math.PI / 4) / Math.PI * 180, secondRelationPosition.X, secondRelationPosition.Y));

            if (this.SecondRelation == Relation.AGGREGATION)
                drawingContext.DrawRectangle(new SolidColorBrush(Colors.White), outlinePen, new Rect(secondRelationPosition.X - symbolSize, secondRelationPosition.Y - symbolSize, symbolSize * 2, symbolSize * 2));

            if (this.SecondRelation == Relation.COMPOSITION)
                drawingContext.DrawRectangle(new SolidColorBrush(Colors.Black), outlinePen, new Rect(secondRelationPosition.X - symbolSize, secondRelationPosition.Y - symbolSize, symbolSize * 2, symbolSize * 2));

            if (this.SecondRelation == Relation.INHERITANCE)
            {

                var segments = new[]
                {
                   new LineSegment(new Point(
                       secondRelationPosition.X - symbolSize,
                       secondRelationPosition.Y - symbolSize), true),
                   new LineSegment(new Point(
                       secondRelationPosition.X - symbolSize,
                       secondRelationPosition.Y + symbolSize), true)
                };

                var figure = new PathFigure(new Point(
                       secondRelationPosition.X + symbolSize,
                       secondRelationPosition.Y + symbolSize), segments, true);
                var geo = new PathGeometry(new[] { figure });
                drawingContext.DrawGeometry(new SolidColorBrush(Colors.White), outlinePen, geo);
            }

            drawingContext.Pop();
        }

        private Point GetLabelPosition(Point p1, Point p2, double labelWidth, bool IsFirst)
        {
            bool isAnchoredOnSide = true;
            if (this.FirstAnchorId != null && IsFirst)
                isAnchoredOnSide = this.FirstAnchorIndex % 2 == 0;

            if (this.SecondAncorId != null && !IsFirst)
                isAnchoredOnSide = this.SecondAncorIndex % 2 == 0;

            double x;
            if (p1.X < p2.X && isAnchoredOnSide || p1.X > p2.X && !isAnchoredOnSide)
                x = p1.X + 10;
            else
                x = p1.X - labelWidth - 10;

            double y;
            if (p1.Y > p2.Y && isAnchoredOnSide || p1.Y < p2.Y && !isAnchoredOnSide)
                y = p1.Y;
            else
                y = p1.Y - 17;

            return new Point(x, y);
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
                this.StylusPoints[this.StylusPoints.Count - 1] = new StylusPoint(newPoint.X, newPoint.Y);
                changed = true;
            }

            if (changed) this.Refresh();
        }

        internal void anchorableDoneMoving(Anchorable anchorable)
        {
            if (((CustomStroke)anchorable).Id.ToString() == this.FirstAnchorId || ((CustomStroke)anchorable).Id.ToString() == this.SecondAncorId)
            {
                EditionSocket.EditStroke(this.toJson());
            }
        }

        public override void RefreshGuids()
        {
            this.Id = Guid.NewGuid();
            this.HandlePoints = new List<Guid>();
            for (int i = 0; i < this.StylusPoints.Count; i++)
                this.HandlePoints.Add(Guid.NewGuid());
            this.FirstAnchorId = null;
            this.SecondAncorId = null;
        }

        public virtual string toJson()
        {
            SerializedStroke toSend = new SerializedStroke()
            {
                Id = this.Id.ToString(),
                ShapeType = this.StrokeType().ToString(),
                Index = this.Index,
                ShapeInfo = GetShapeInfo(),
                ImageId = ServerService.instance.currentImageId
            };
            return JsonConvert.SerializeObject(toSend);
        }

        public StrokeType StrokeType() => Strokes.StrokeType.LINE;

        public LineInfo GetShapeInfo()
        {
            List<ShapePoint> points = new List<ShapePoint>();
            for (int i = 0; i < this.StylusPoints.Count; i++)
            {
                points.Add(new ShapePoint() { X = this.StylusPoints[i].X, Y = this.StylusPoints[i].Y });
            }
            return new LineInfo()
            {
                Points = points,
                FirstAnchorId = this.FirstAnchorId,
                FirstAnchorIndex = this.FirstAnchorIndex,
                SecondAnchorId = this.SecondAncorId,
                SecondAnchorIndex = this.SecondAncorIndex,
                FirstEndLabel = this.FirstText,
                FirstEndRelation = this.FirstRelation.ToString(),
                SecondEndLabel = this.SecondText,
                SecondEndRelation = this.SecondRelation.ToString()
            };
        }
    }

    public enum Relation
    {
        ASSOCIATION, AGGREGATION, COMPOSITION, INHERITANCE
    }
}
