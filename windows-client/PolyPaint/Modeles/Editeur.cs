using Newtonsoft.Json.Linq;
using PolyPaint.Modeles.Outils;
using PolyPaint.Modeles.Strokes;
using PolyPaint.Modeles.Tools;
using PolyPaint.Services;
using RestSharp;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;

namespace PolyPaint.Modeles
{
    /// <summary>
    /// Modélisation de l'éditeur.
    /// Contient ses différents états et propriétés ainsi que la logique
    /// qui régis son fonctionnement.
    /// </summary>
    public class Editeur : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        public CustomStrokeCollection traits = new CustomStrokeCollection();
        private CustomStrokeCollection traitsRetires = new CustomStrokeCollection();

        private Tool EditTool = new Edit();
        private Tool Lasso = new Lasso();
        private Tool ObjectEraser = new ObjectEraser();
        private Tool Rectangle = new Rectangle();
        private Tool Elipse = new Elipse();
        private Tool Triangle = new Triangle();
        private Tool Person = new Person();
        private Tool Line = new Line();
        private Tool ClassDiagram = new ClassDiagram();
        private Tool UseCase = new UseCase();
        public List<Tool> Tools;

        // Outil actif dans l'éditeur
        private Tool outilSelectionne;
        public Tool OutilSelectionne
        {
            get { return outilSelectionne; }
            set
            {
                outilSelectionne = value;
                if (this.outilSelectionne != EditTool)
                {
                    this.EditingStroke = null;
                    this.traits.ToList().ForEach(stroke =>
                    {
                        if (((CustomStroke)stroke).isSelectable())
                            ((CustomStroke)stroke).Unselect();
                    });
                }

                this.traits.ToList().FindAll(stroke => stroke is Anchorable).ForEach(stroke =>
                {
                    if (this.outilSelectionne == Line)
                        ((Anchorable)stroke).showAnchorPoints();
                    else
                        ((Anchorable)stroke).hideAnchorPoints();
                });

                ProprieteModifiee();
            }
        }

        public string ActiveItemTextContent
        {
            get
            {
                if (this.traits.has(this.EditingStroke))
                {
                    CustomStroke editing = this.traits.get(this.EditingStroke);
                    if (editing is Textable)
                        return ((Textable)editing).GetText();
                }
                return "";
            }
            set
            {
                if (this.traits.has(this.EditingStroke))
                {
                    CustomStroke editing = this.traits.get(this.EditingStroke);
                    if (editing is Textable)
                        ((Textable)editing).SetText(value);
                }
                this.ProprieteModifiee();
            }
        }

        public string FirstLabel
        {
            get
            {
                if (!this.traits.has(EditingStroke)) return "";
                CustomStroke stroke = (CustomStroke)this.traits.get(EditingStroke);
                if (!(stroke is BaseLine)) return "";
                return ((BaseLine)stroke).getFirstLabel();
            }
            set
            {
                if (!this.traits.has(EditingStroke)) return;
                CustomStroke stroke = (CustomStroke)this.traits.get(EditingStroke);
                if (!(stroke is BaseLine)) return;
                ((BaseLine)stroke).setFirstLabel(value);
                this.ProprieteModifiee();
            }
        }

        public string SecondLabel
        {
            get
            {
                if (!this.traits.has(EditingStroke)) return "";
                CustomStroke stroke = (CustomStroke)this.traits.get(EditingStroke);
                if (!(stroke is BaseLine)) return "";
                return ((BaseLine)stroke).getSecondLabel();
            }
            set
            {
                if (!this.traits.has(EditingStroke)) return;
                CustomStroke stroke = (CustomStroke)this.traits.get(EditingStroke);
                if (!(stroke is BaseLine)) return;
                ((BaseLine)stroke).setSecondLabel(value);
                this.ProprieteModifiee();
            }
        }

        public Relation FirstRelation
        {
            get
            {
                if (!this.traits.has(EditingStroke)) return Relation.ASSOCIATION;
                CustomStroke stroke = (CustomStroke)this.traits.get(EditingStroke);
                if (!(stroke is BaseLine)) return Relation.ASSOCIATION;
                return ((BaseLine)stroke).getFirstRelation();
            }
            set
            {
                if (!this.traits.has(EditingStroke)) return;
                CustomStroke stroke = (CustomStroke)this.traits.get(EditingStroke);
                if (!(stroke is BaseLine)) return;
                ((BaseLine)stroke).setFirstRelation(value);
                this.ProprieteModifiee();
            }
        }

        public Relation SecondRelation
        {
            get
            {
                if (!this.traits.has(EditingStroke)) return Relation.ASSOCIATION;
                CustomStroke stroke = (CustomStroke)this.traits.get(EditingStroke);
                if (!(stroke is BaseLine)) return Relation.ASSOCIATION;
                return ((BaseLine)stroke).getSecondRelation();
            }
            set
            {
                if (!this.traits.has(EditingStroke)) return;
                CustomStroke stroke = (CustomStroke)this.traits.get(EditingStroke);
                if (!(stroke is BaseLine)) return;
                ((BaseLine)stroke).setSecondRelation(value);
                this.ProprieteModifiee();
            }
        }

        private string editingStroke;
        public string EditingStroke
        {
            get { return editingStroke; }
            set
            {
                if (this.editingStroke != null && this.traits.has(this.editingStroke))
                {
                    this.traits.get(this.editingStroke).stopEditing();
                }

                this.editingStroke = value;

                if (this.editingStroke != null)
                    this.OutilSelectionne = this.EditTool;

                ProprieteModifiee();
                ProprieteModifiee("ActiveItemTextContent");
                ProprieteModifiee("FirstLabel");
                ProprieteModifiee("SecondLabel");
                ProprieteModifiee("FirstRelation");
                ProprieteModifiee("SecondRelation");
            }
        }

        // Couleur des traits tracés par le crayon.
        private string couleurSelectionnee = "White";
        public string CouleurSelectionnee
        {
            get { return couleurSelectionnee; }
            // Lorsqu'on sélectionne une couleur c'est généralement pour ensuite dessiner un trait.
            // C'est pourquoi lorsque la couleur est changée, l'outil est automatiquement changé pour le crayon.
            set
            {
                couleurSelectionnee = value;
                ProprieteModifiee();
            }
        }

        // Grosseur des traits tracés par le crayon.
        private int tailleTrait = 11;
        public int TailleTrait
        {
            get { return tailleTrait; }
            // Lorsqu'on sélectionne une taille de trait c'est généralement pour ensuite dessiner un trait.
            // C'est pourquoi lorsque la taille est changée, l'outil est automatiquement changé pour le crayon.
            set
            {
                tailleTrait = value;
                ProprieteModifiee();
            }
        }

        public Editeur()
        {
            this.outilSelectionne = this.EditTool;

            this.Tools = new List<Tool>
            {
                EditTool,
                Lasso,
                ObjectEraser,
                Rectangle,
                Elipse,
                Triangle,
                Person,
                Line,
                ClassDiagram,
                UseCase
            };
        }

        /// <summary>
        /// Appelee lorsqu'une propriété d'Editeur est modifiée.
        /// Un évènement indiquant qu'une propriété a été modifiée est alors émis à partir d'Editeur.
        /// L'évènement qui contient le nom de la propriété modifiée sera attrapé par VueModele qui pourra
        /// alors prendre action en conséquence.
        /// </summary>
        /// <param name="propertyName">Nom de la propriété modifiée.</param>
        protected void ProprieteModifiee([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        // S'il y a au moins 1 trait sur la surface, il est possible d'exécuter Empiler.
        public bool PeutEmpiler(object o) => (traits.Count > 0);

        internal void MouseUp(Point point)
        {
            this.outilSelectionne.MouseUp(point, traits);
        }

        internal void SelectStrokes(StrokeCollection strokes)
        {
            strokes.ToList().ForEach(stroke =>
            {
                if (((CustomStroke)stroke).isSelected())
                {
                    if (((CustomStroke)stroke).isEditing())
                        this.EditingStroke = null;

                    ((CustomStroke)stroke).Unselect();
                }
                else
                {
                    ((CustomStroke)stroke).Select();
                }
            });
        }

        internal void Edit(CustomStroke stroke)
        {
            if (stroke.isLocked()) return;
            if (!stroke.isSelected())
            {
                this.traits.ToList().ForEach(s =>
                {
                    if (((CustomStroke)s).isSelectable())
                        ((CustomStroke)s).Unselect();
                });

                StrokeCollection sc = new StrokeCollection();
                sc.Add(stroke);
                this.SelectStrokes(sc);
            };

            if (stroke.isEditing())
            {
                this.EditingStroke = null;
            }
            else
            {
                stroke.startEditing();
                this.EditingStroke = stroke.Id.ToString();
            }
        }

        internal void MouseMove(Point point)
        {
            this.outilSelectionne.MouseMove(point, traits, (Color)ColorConverter.ConvertFromString(couleurSelectionnee));
            this.traits.ToList().ForEach(stroke =>
            {
                if (stroke is AnchorPoint)
                {
                    ((AnchorPoint)stroke).Hover = ((CustomStroke)stroke).HitTest(point);
                }
            });
        }

        internal void MouseDown(Point point)
        {
            this.outilSelectionne.MouseDown(point, traits);
        }

        // On retire le trait le plus récent de la surface de dessin et on le place sur une pile.
        public void Empiler(object o)
        {
            try
            {
                EditingStroke = null;
                Stroke trait = traits.Last();
                traitsRetires.Add(trait);
                traits.Remove(trait);
            }
            catch { }

        }

        // S'il y a au moins 1 trait sur la pile de traits retirés, il est possible d'exécuter Depiler.
        public bool PeutDepiler(object o) => (traitsRetires.Count > 0);
        // On retire le trait du dessus de la pile de traits retirés et on le place sur la surface de dessin.
        public void Depiler(object o)
        {
            try
            {
                Stroke trait = traitsRetires.Last();
                traits.Add(trait);
                traitsRetires.Remove(trait);
            }
            catch { }
        }

        // L'outil actif devient celui passé en paramètre.
        public void ChoisirOutil(Tool tool) => OutilSelectionne = tool;

        // On vide la surface de dessin de tous ses traits.
        public void Reinitialiser(object o) => traits.Clear();

        public void SyncToServer()
        {
            ServerService.instance.Socket.Emit("joinImage", ServerService.instance.currentImageId);

            ServerService.instance.Socket.On("imageData", new CustomListener((object[] server_params) =>
            {
                Application.Current.Dispatcher.Invoke(() => this.Load((JArray)server_params[0]));
            }));

            ServerService.instance.Socket.On("addStroke", new CustomListener((object[] server_params) =>
            {

            }));

            ServerService.instance.Socket.On("editStroke", new CustomListener((object[] server_params) =>
            {

            }));

            ServerService.instance.Socket.On("removeStroke", new CustomListener((object[] server_params) =>
            {

            }));

            ServerService.instance.Socket.On("protection", new CustomListener((object[] server_params) =>
            {

            }));
        }

        public void Load(JArray shapeObjects)
        {
            traits.Clear();
            traitsRetires.Clear();
            
            for (int i = 0; i < shapeObjects.Count; i++)
            {
                this.traits.Add(SerializationHelper.stringToStroke(shapeObjects[i].ToString(), this.traits));

                //dynamic shape = JObject.Parse(shapeObjects[i].ToString());
                //if (shape["ShapeType"] != StrokeType.LINE.ToString())
                //{
                //    StylusPoint topLeft = new StylusPoint((double)(shape["ShapeInfo"]["Center"]["X"] - shape["ShapeInfo"]["Width"] / 2),
                //        (double)(shape["ShapeInfo"]["Center"]["Y"] - shape["ShapeInfo"]["Height"] / 2));
                //    StylusPoint bottomRight = new StylusPoint((double)(shape["ShapeInfo"]["Center"]["X"] + shape["ShapeInfo"]["Width"] / 2),
                //        (double)(shape["ShapeInfo"]["Center"]["Y"] + shape["ShapeInfo"]["Height"] / 2));

                //    ShapeStroke loadedShape;

                //    if (shape["ShapeType"] == StrokeType.RECTANGLE.ToString())
                //    {
                //        loadedShape = new BaseRectangleStroke(new StylusPointCollection() { topLeft, bottomRight }, traits);
                //    }
                //    else if (shape["ShapeType"] == StrokeType.ELIPSE.ToString())
                //    {
                //        loadedShape = new BaseElipseStroke(new StylusPointCollection() { topLeft, bottomRight }, traits);
                //    }
                //    else if (shape["ShapeType"] == StrokeType.TRIANGLE.ToString())
                //    {
                //        loadedShape = new BaseTrangleStroke(new StylusPointCollection() { topLeft, bottomRight }, traits);

                //    }
                //    else if (shape["ShapeType"] == StrokeType.ACTOR.ToString())
                //    {
                //        loadedShape = new PersonStroke(new StylusPointCollection() { topLeft, bottomRight }, traits);
                //        ((PersonStroke)loadedShape).Name = "";
                //        for (int j = 0; j < shape["ShapeInfo"]["Content"].Count; j++)
                //        {
                //            ((PersonStroke)loadedShape).Name += shape["ShapeInfo"]["Content"][j] + " ";
                //        }
                //    }
                //    else if (shape["ShapeType"] == StrokeType.CLASS.ToString())
                //    {
                //        loadedShape = new ClassStroke(new StylusPointCollection() { topLeft, bottomRight }, traits);
                //        ((ClassStroke)loadedShape).textContent = new List<string>();
                //        for (int j = 0; j < shape["ShapeInfo"]["Content"].Count; j++)
                //        {
                //            ((ClassStroke)loadedShape).textContent.Add((string)shape["ShapeInfo"]["Content"][j]);
                //        }
                //    }
                //    else
                //    {
                //        loadedShape = new UseCaseStroke(new StylusPointCollection() { topLeft, bottomRight }, traits);
                //        ((UseCaseStroke)loadedShape).textContent = new List<string>();
                //        for (int j = 0; j < shape["ShapeInfo"]["Content"].Count; j++)
                //        {
                //            ((UseCaseStroke)loadedShape).textContent.Add((string)shape["ShapeInfo"]["Content"][j]);
                //        }
                //    }
                //    loadedShape.Id = shape["Id"];
                //    loadedShape.DrawingAttributes.Color = (Color)ColorConverter.ConvertFromString((string)shape["ShapeInfo"]["Color"]);
                //    traits.Add(loadedShape);
                //}
                //else
                //{
                //    StylusPointCollection points = new StylusPointCollection();
                //    for (int j = 0; j < shape["ShapeInfo"]["Points"].Count; j++)
                //    {
                //        points.Add(new StylusPoint((double)shape["ShapeInfo"]["Points"][j]["X"], (double)shape["ShapeInfo"]["Points"][j]["Y"]));
                //    }
                //    BaseLine loadedLine = new BaseLine(points, traits)
                //    {
                //        Id = shape["Id"],
                //        FirstAnchorId = shape["ShapeInfo"]["FirstAnchorId"],
                //        FirstAnchorIndex = shape["ShapeInfo"]["FirstAnchorIndex"],
                //        SecondAncorId = shape["ShapeInfo"]["SecondAnchorId"],
                //        SecondAncorIndex = shape["ShapeInfo"]["SecondAnchorIndex"],
                //        FirstText = shape["ShapeInfo"]["FirstEndLabel"],
                //        FirstRelation = shape["ShapeInfo"]["FirstEndRelation"],
                //        SecondText = shape["ShapeInfo"]["SecondEndLabel"],
                //        SecondRelation = shape["ShapeInfo"]["SecondEndRelation"]
                //    };
                //    traits.Add(loadedLine);
                //}
            }
        }
    }
}