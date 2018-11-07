using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles.Strokes
{
    public interface Textable
    {
        void SetText(string text);
        string GetText();
    }
}
