using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using PolyPaint.Modeles.Strokes;

namespace PolyPaint.Modeles.Actions
{
    class NewStroke : EditionAction
    {
        private string SerializedStroke;

        public NewStroke(string id, string serializedStroke) : base(id)
        {
            this.Id = id;
            this.SerializedStroke = serializedStroke;
        }

        public override void Redo(CustomStrokeCollection strokes)
        {
            if (!strokes.has(Id))
            {
                strokes.Add(SerializationHelper.stringToStroke(JObject.Parse(SerializedStroke), strokes));
                EditionSocket.AddStroke(SerializedStroke);
            }
        }

        public override void Undo(CustomStrokeCollection strokes)
        {
            if (strokes.has(Id))
            {
                CustomStroke old = strokes.get(Id);
                if (old.isLocked()) throw new Exception("Stroke is Locked");

                strokes.Remove(strokes.get(Id));
                EditionSocket.RemoveStroke(Id);
            }
        }
    }
}
