using Newtonsoft.Json.Linq;
using PolyPaint.Modeles.Strokes;
using System.Collections.Generic;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles
{
    public static class ShapeLoader
    {
        public static void LoadShape(string strignifiedStroke, CustomStrokeCollection strokes)
        {
            dynamic shape = JObject.Parse(strignifiedStroke);
            if (shape["ShapeType"] != StrokeType.LINE.ToString())
            {
                LoadForm(shape, strokes);
            }
            else
            {
                LoadLine(shape, strokes);
            }
        }

        private static void LoadForm(dynamic shape, CustomStrokeCollection strokes)
        {
            StylusPoint topLeft = new StylusPoint((double)(shape["ShapeInfo"]["Center"]["X"] - shape["ShapeInfo"]["Width"] / 2),
                    (double)(shape["ShapeInfo"]["Center"]["Y"] - shape["ShapeInfo"]["Height"] / 2));
            StylusPoint bottomRight = new StylusPoint((double)(shape["ShapeInfo"]["Center"]["X"] + shape["ShapeInfo"]["Width"] / 2),
                (double)(shape["ShapeInfo"]["Center"]["Y"] + shape["ShapeInfo"]["Height"] / 2));

            ShapeStroke loadedShape;

            if (shape["ShapeType"] == StrokeType.RECTANGLE.ToString())
            {
                loadedShape = new BaseRectangleStroke(new StylusPointCollection() { topLeft, bottomRight }, strokes);
            }
            else if (shape["ShapeType"] == StrokeType.ELLIPSE.ToString())
            {
                loadedShape = new BaseElipseStroke(new StylusPointCollection() { topLeft, bottomRight }, strokes);
            }
            else if (shape["ShapeType"] == StrokeType.TRIANGLE.ToString())
            {
                loadedShape = new BaseTrangleStroke(new StylusPointCollection() { topLeft, bottomRight }, strokes);

            }
            else if (shape["ShapeType"] == StrokeType.ACTOR.ToString())
            {
                loadedShape = new PersonStroke(new StylusPointCollection() { topLeft, bottomRight }, strokes);
                ((PersonStroke)loadedShape).Name = "";
                for (int j = 0; j < shape["ShapeInfo"]["Content"].Count; j++)
                {
                    ((PersonStroke)loadedShape).Name += shape["ShapeInfo"]["Content"][j] + " ";
                }
            }
            else if (shape["ShapeType"] == StrokeType.CLASS.ToString())
            {
                loadedShape = new ClassStroke(new StylusPointCollection() { topLeft, bottomRight }, strokes);
                ((ClassStroke)loadedShape).textContent = new List<string>();
                for (int j = 0; j < shape["ShapeInfo"]["Content"].Count; j++)
                {
                    ((ClassStroke)loadedShape).textContent.Add((string)shape["ShapeInfo"]["Content"][j]);
                }
            }
            else
            {
                loadedShape = new UseCaseStroke(new StylusPointCollection() { topLeft, bottomRight }, strokes);
                ((UseCaseStroke)loadedShape).textContent = new List<string>();
                for (int j = 0; j < shape["ShapeInfo"]["Content"].Count; j++)
                {
                    ((UseCaseStroke)loadedShape).textContent.Add((string)shape["ShapeInfo"]["Content"][j]);
                }
            }
            loadedShape.Id = shape["Id"];
            loadedShape.DrawingAttributes.Color = (Color)ColorConverter.ConvertFromString((string)shape["ShapeInfo"]["Color"]);
            strokes.Add(loadedShape);
        }

        private static void LoadLine(dynamic shape, CustomStrokeCollection strokes)
        {
            StylusPointCollection points = new StylusPointCollection();
            for (int j = 0; j < shape["ShapeInfo"]["Points"].Count; j++)
            {
                points.Add(new StylusPoint((double)shape["ShapeInfo"]["Points"][j]["X"], (double)shape["ShapeInfo"]["Points"][j]["Y"]));
            }
            BaseLine loadedLine = new BaseLine(points, strokes)
            {
                Id = shape["Id"],
                FirstAnchorId = shape["ShapeInfo"]["FirstAnchorId"],
                FirstAnchorIndex = shape["ShapeInfo"]["FirstAnchorIndex"],
                SecondAncorId = shape["ShapeInfo"]["SecondAnchorId"],
                SecondAncorIndex = shape["ShapeInfo"]["SecondAnchorIndex"],
                FirstText = shape["ShapeInfo"]["FirstEndLabel"],
                FirstRelation = shape["ShapeInfo"]["FirstEndRelation"],
                SecondText = shape["ShapeInfo"]["SecondEndLabel"],
                SecondRelation = shape["ShapeInfo"]["SecondEndRelation"]
            };
            strokes.Add(loadedLine);
        }
    }
}
