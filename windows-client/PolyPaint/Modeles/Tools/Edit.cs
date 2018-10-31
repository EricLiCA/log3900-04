using PolyPaint.Modeles.Outils;
using PolyPaint.Modeles.Strokes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Tools
{
    class Edit : Tool
    {
        private Movable editing;
        private Point initialCursorPosition;
        private StylusPointCollection initialObjectPoints;

        public override string GetToolImage()
        {
            return "/Resources/cursor.png";
        }

        public override string GetToolName()
        {
            return "edit";
        }

        public override string GetToolTooltip()
        {
            return "Edit";
        }

        public override void MouseDown(Point point, CustomStrokeCollection strokes)
        {
            if (editing != null) return;

            List<Stroke> clicked = strokes.ToList().FindAll(stroke => ((CustomStroke)stroke).HitTest(point) && stroke is Movable);
            List<Stroke> clickedHandles = clicked.FindAll(stroke => stroke is DragHandle);
            List<Stroke> clickedSelected = clicked.FindAll(stroke => ((CustomStroke)stroke).isSelected());

            if (clickedHandles.Count > 0)
            {
                this.initialCursorPosition = point;
                this.initialObjectPoints = clicked.Last().StylusPoints;
                this.editing = (Movable)clickedHandles.Last();
                return;
            }

            if (clickedSelected.Count > 0)
            {
                this.initialCursorPosition = point;
                this.initialObjectPoints = clicked.Last().StylusPoints;
                this.editing = (Movable)clickedSelected.Last();
            }
        }

        public override void MouseMove(Point point, CustomStrokeCollection strokes, Color selectedColor)
        {
            if (editing == null) return;

            Vector displacement = new Vector(point.X - initialCursorPosition.X, point.Y - initialCursorPosition.Y);
            StylusPointCollection newPoints = new StylusPointCollection();
            this.initialObjectPoints.ToList().ForEach(originalPoint =>
            {
                if (editing is ShapeStroke)
                    newPoints.Add(new StylusPoint(originalPoint.X + displacement.X, originalPoint.Y + displacement.Y));
                else
                    newPoints.Add(new StylusPoint(point.X, point.Y));
            });

            this.editing.Move(newPoints);
        }

        public override void MouseUp(Point point, CustomStrokeCollection strokes)
        {
            this.editing = null;
        }
    }
}
