using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace PolyPaint.Modeles.Strokes
{
    public class SerializationHelper
    {
    }

    public class SerializedStroke
    {
        public Guid Id;
        public string Type;
        public int Index;
        public string ShapeInfo;
    }

    public class ShapeInfo
    {
        public Point Center;
        public double Width;
        public double Height;
    }

    public class TextableShapeInfo : ShapeInfo
    {
        public List<string> Content;
    }
     
    public class LineInfo
    {
        public List<Point> Points;

        public string FirstAnchorId;
        public int FirstAnchorIndex;
        public string SecondAnchorId;
        public int SecondAnchorIndex;

        public string FirstEndLabel;
        public string FirstEndRelation;
        public string SecondEndLabel;
        public string SecondEndRelation;
    }
}
