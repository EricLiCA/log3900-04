using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Ink;
using Newtonsoft.Json.Linq;
using PolyPaint.Modeles.Strokes;

namespace PolyPaint.Modeles.Actions
{
    class EditStroke : EditionAction
    {
        public string SerializedStrokeBefore;
        public string SerializedStrokeAfter;

        public EditStroke(string id, string serializedStrokeBefore, string serializedStrokeAfter) : base(id)
        {
            this.Id = id;
            this.SerializedStrokeBefore = serializedStrokeBefore;
            this.SerializedStrokeAfter = serializedStrokeAfter;
        }

        public override void Redo(CustomStrokeCollection strokes)
        {
            if (strokes.has(Id))
            {
                CustomStroke old = strokes.get(Id);
                if (old.isLocked()) throw new Exception("Stroke is Locked");

                EditionSocket.EditStroke(SerializedStrokeAfter);

                CustomStroke updated = SerializationHelper.stringToStroke(JObject.Parse(SerializedStrokeAfter), strokes);
                bool selected = ((CustomStroke)old).isSelected();
                bool editting = ((CustomStroke)old).isEditing();
                ((CustomStroke)old).stopEditing();
                strokes.Remove(strokes.get(Id));

                int newindex = strokes.ToList().FindIndex(stroke => ((CustomStroke)stroke).Index > updated.Index);

                try
                {
                    strokes.Insert(newindex, updated);
                }
                catch
                {
                    strokes.Add(updated);
                }

                if (selected) strokes.get(Id).Select();
                if (editting) strokes.get(Id).startEditing();

                if (updated is Anchorable)
                    strokes.ToList().FindAll(stroke => stroke is BaseLine).ForEach(stroke => ((BaseLine)stroke).anchorableMoved((Anchorable)updated));
            }
        }

        public override void Undo(CustomStrokeCollection strokes)
        {
            if (strokes.has(Id))
            {
                CustomStroke old = strokes.get(Id);
                if (old.isLocked()) throw new Exception("Stroke is Locked");

                EditionSocket.EditStroke(SerializedStrokeBefore);

                CustomStroke updated = SerializationHelper.stringToStroke(JObject.Parse(SerializedStrokeBefore), strokes);
                bool selected = ((CustomStroke)old).isSelected();
                bool editting = ((CustomStroke)old).isEditing();
                ((CustomStroke)old).stopEditing();
                strokes.Remove(strokes.get(Id));

                int newindex = strokes.ToList().FindIndex(stroke => ((CustomStroke)stroke).Index > updated.Index);

                try
                {
                    strokes.Insert(newindex, updated);
                }
                catch
                {
                    strokes.Add(updated);
                }

                if (selected) strokes.get(updated.Id.ToString()).Select();
                if (editting) strokes.get(updated.Id.ToString()).startEditing();

                if (updated is Anchorable)
                    strokes.ToList().FindAll(stroke => stroke is BaseLine).ForEach(stroke => ((BaseLine)stroke).anchorableMoved((Anchorable)updated));
            }
        }

        internal void UpdateAfter(string serializedStrokeAfter)
        {
            this.SerializedStrokeAfter = serializedStrokeAfter;
        }
    }
}
