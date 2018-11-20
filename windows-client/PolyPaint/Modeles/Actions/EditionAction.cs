using PolyPaint.Modeles.Strokes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles.Actions
{
    public abstract class EditionAction
    {
        public string Id;

        public EditionAction(string id)
        {
            this.Id = id;
        }

        public abstract void Undo(CustomStrokeCollection strokes);
        public abstract void Redo(CustomStrokeCollection strokes);
    }
}
