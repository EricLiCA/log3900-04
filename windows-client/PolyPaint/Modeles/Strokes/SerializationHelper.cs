using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles.Strokes
{
    public class SerializationHelper
    {
        public static CustomStroke stringToStroke(JObject serialized, CustomStrokeCollection strokes)
        {
            switch (serialized.ToObject<SerializedStroke>().ShapeType)
            {
                case "RECTANGLE":
                    SerializedShape rectangle = serialized.ToObject<SerializedShape>();
                    var rectangleStroke = new BaseRectangleStroke(rectangle.Id, rectangle.Index, getExtrimities(rectangle.ShapeInfo), strokes, (Color)ColorConverter.ConvertFromString(rectangle.ShapeInfo.Color));
                    return rectangleStroke;

                case "TRIANGLE":
                    SerializedShape triangle = serialized.ToObject<SerializedShape>();
                    var triangleStroke = new BaseTrangleStroke(triangle.Id, triangle.Index, getExtrimities(triangle.ShapeInfo), strokes, (Color)ColorConverter.ConvertFromString(triangle.ShapeInfo.Color));
                    return triangleStroke;

                case "ELLIPSE":
                    SerializedShape elipse = serialized.ToObject<SerializedShape>();
                    var elipseStroke = new BaseElipseStroke(elipse.Id, elipse.Index, getExtrimities(elipse.ShapeInfo), strokes, (Color)ColorConverter.ConvertFromString(elipse.ShapeInfo.Color));
                    return elipseStroke;

                case "CLASS":
                    SerializedTextable classCase = serialized.ToObject<SerializedTextable>();
                    var classStroke = new ClassStroke(classCase.Id, classCase.Index, getExtrimities(classCase.ShapeInfo), strokes, classCase.ShapeInfo.Content);
                    return classStroke;

                case "USE":
                    SerializedTextable use = serialized.ToObject<SerializedTextable>();
                    var useStroke = new UseCaseStroke(use.Id, use.Index, getExtrimities(use.ShapeInfo), strokes, use.ShapeInfo.Content);
                    return useStroke;

                case "ACTOR":
                    SerializedTextable actor = serialized.ToObject<SerializedTextable>();
                    var actorStroke = new PersonStroke(actor.Id, actor.Index, getExtrimities(actor.ShapeInfo), strokes, actor.ShapeInfo.Content[0]);
                    return actorStroke;

                case "LINE":
                    SerializedLine line = serialized.ToObject<SerializedLine>();

                    var points = line.ShapeInfo.Points.ConvertAll<StylusPoint>(point =>
                    {
                        return new StylusPoint(point.X, point.Y);
                    });

                    var lineStroke = new BaseLine(
                        line.Id, line.Index, new StylusPointCollection(points), strokes,
                        line.ShapeInfo.FirstAnchorId, line.ShapeInfo.FirstAnchorIndex,
                        line.ShapeInfo.SecondAnchorId, line.ShapeInfo.SecondAnchorIndex,
                        line.ShapeInfo.FirstEndLabel, line.ShapeInfo.SecondEndLabel,
                        line.ShapeInfo.FirstEndRelation, line.ShapeInfo.SecondEndRelation);
                    return lineStroke;
            }



            return null;
        }

        private static StylusPointCollection getExtrimities(ShapeInfo info)
        {
            return new StylusPointCollection() {
                new StylusPoint(info.Center.X - info.Width / 2, info.Center.Y - info.Height / 2),
                new StylusPoint(info.Center.X + info.Width / 2, info.Center.Y + info.Height / 2)
            };
        }
    }

    public class SerializedStroke
    {
        public string Id;
        public string ShapeType;
        public int Index;
        public string ImageId;
        public Info ShapeInfo;
    }

    public class SerializedShape : SerializedStroke
    {
        public new ShapeInfo ShapeInfo;
    }

    public class SerializedTextable : SerializedStroke
    {
        public new TextableShapeInfo ShapeInfo;
    }

    public class SerializedLine : SerializedStroke
    {
        public new LineInfo ShapeInfo;
    }

    public class ShapePoint
    {
        public double X;
        public double Y;
    }

    public class Info
    {
    }

    public class ShapeInfo : Info
    {
        public ShapePoint Center;
        public double Width;
        public double Height;
        public string Color;
    }
    
    public class TextableShapeInfo : ShapeInfo
    {
        public List<string> Content;
    }
     
    public class LineInfo : Info
    {
        public List<ShapePoint> Points;

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
