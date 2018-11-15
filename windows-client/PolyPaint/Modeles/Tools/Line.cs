using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using PolyPaint.Modeles.Outils;
using PolyPaint.Modeles.Strokes;

namespace PolyPaint.Modeles.Tools
{
    class Line : Tool
    {
        private bool IsDrawing;
        private Point MouseLeftDownPoint;
        private Stroke ActiveStroke;

        private string FirstAnchorPointId;
        private int FirstAnchorPointIndex = -1;

        public override string GetToolImage()
        {
            return "/Resources/line-tool.png";
        }

        public override string GetToolName()
        {
            return "line";
        }

        public override string GetToolTooltip()
        {
            return "Line";
        }

        public override void MouseDown(Point point, CustomStrokeCollection strokes)
        {
            IsDrawing = true;
            MouseLeftDownPoint = point;

            List<Stroke> hoveredAnchors = strokes.ToList().FindAll( stroke => stroke is AnchorPoint && ((CustomStroke)stroke).HitTest(point));
            if (hoveredAnchors.Count > 0)
            {
                AnchorPoint anchor = (AnchorPoint)hoveredAnchors.Last();
                this.FirstAnchorPointId = anchor.ParentId;
                this.FirstAnchorPointIndex = anchor.AnchorIndex;
                MouseLeftDownPoint = anchor.Parent.getAnchorPointPosition(this.FirstAnchorPointIndex);
            }

        }

        public override void MouseMove(Point point, CustomStrokeCollection strokes, Color selectedColor)
        {
            if (!IsDrawing) return;

            string secondId = null;
            int secondIndex = -1;
            List<Stroke> hoveredAnchors = strokes.ToList().FindAll(stroke => stroke is AnchorPoint && ((CustomStroke)stroke).HitTest(point));
            if (hoveredAnchors.Count > 0)
            {
                AnchorPoint anchor = (AnchorPoint)hoveredAnchors.Last();
                point = anchor.Parent.getAnchorPointPosition(anchor.AnchorIndex);
                secondId = anchor.ParentId;
                secondIndex = anchor.AnchorIndex;
            }

            StylusPointCollection pts = new StylusPointCollection
            {
                new StylusPoint(MouseLeftDownPoint.X, MouseLeftDownPoint.Y),
                new StylusPoint(point.X, point.Y)
            };

            if (ActiveStroke != null)
                strokes.Remove(ActiveStroke);

            if (this.FirstAnchorPointId == null)
            {
                if (secondId == null)
                {
                    ActiveStroke = new BaseLine(pts, strokes);
                }
                else
                {
                    ActiveStroke = new BaseLine(pts, strokes, null, -1, secondId, secondIndex);
                }
            }
            else
            {
                if (secondId == null)
                {
                    ActiveStroke = new BaseLine(pts, strokes, this.FirstAnchorPointId, this.FirstAnchorPointIndex, null, -1);
                }
                else
                {
                    ActiveStroke = new BaseLine(pts, strokes, this.FirstAnchorPointId, this.FirstAnchorPointIndex, secondId, secondIndex);
                }
            }

            ActiveStroke.DrawingAttributes.Color = selectedColor;
            strokes.Add(ActiveStroke);
        }

        public override void MouseUp(Point point, CustomStrokeCollection strokes)
        {
            if (ActiveStroke != null)
            {
                strokes.Remove(ActiveStroke);
                strokes.Add(ActiveStroke.Clone());
                EditionSocket.AddStroke(((Savable)ActiveStroke).toJson());
            }
            IsDrawing = false;
            this.FirstAnchorPointId = null;
        }
    }
}
