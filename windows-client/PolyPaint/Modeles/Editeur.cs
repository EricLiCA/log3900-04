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
        private Tool TextTool = new TextTool();
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
                    EditionSocket.UnlockStrokes();
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
                Console.WriteLine(">---000---");
                Console.WriteLine(editingStroke);
                Console.WriteLine(value);
                Console.WriteLine("---000---<");

                if (this.editingStroke != null && this.traits.has(this.editingStroke))
                {
                    Console.WriteLine("------is");
                    this.traits.get(this.editingStroke).stopEditing();
                    Console.WriteLine("------is" + this.traits.get(this.editingStroke).isEditing());
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

        private string waitingEdit;

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
                UseCase,
                TextTool
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
            if (strokes.Count == 0) return;

            this.EditingStroke = null;
            List<string> toProtect = new List<string>();
            strokes.ToList().ForEach(stroke =>
            {
                if (!((CustomStroke)stroke).isSelected() && !((CustomStroke)stroke).isLocked())
                    toProtect.Add(((CustomStroke)stroke).Id.ToString());
            });
            EditionSocket.LockStroke(toProtect);
        }

        internal void Edit(CustomStroke s)
        {
            var stroke = this.traits.get(s.Id.ToString());
            if (stroke.isLocked()) return;

            if (stroke.isEditing())
                this.EditingStroke = null;
            else
            {
                if (stroke.isSelected())
                {
                    stroke.startEditing();
                    this.EditingStroke = stroke.Id.ToString();
                }
                else
                {
                    EditionSocket.LockStroke(new List<string>() { stroke.Id.ToString() });
                    this.EditingStroke = null;
                    this.waitingEdit = stroke.Id.ToString();
                }
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
        public void Empiler(Object o)
        {
            try
            {
                EditingStroke = null;
                Stroke trait = traits.Last();
                traitsRetires.Add(trait);
                traits.Remove(trait);
                EditionSocket.RemoveStroke(((CustomStroke)trait).Id.ToString());
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
                EditionSocket.AddStroke(((Savable)trait).toJson());
                traitsRetires.Remove(trait);
            }
            catch { }
        }

        // L'outil actif devient celui passé en paramètre.
        public void ChoisirOutil(Tool tool) => OutilSelectionne = tool;

        // On vide la surface de dessin de tous ses traits.
        public void Reinitialiser(object o)  {
            traits.Clear();
            EditionSocket.ClearCanvas();
        }

        public void SyncToServer()
        {
            ServerService.instance.Socket.Emit("joinImage", ServerService.instance.currentImageId);

            ServerService.instance.Socket.On("imageData", new CustomListener((object[] server_params) =>
            {
                Application.Current.Dispatcher.Invoke(() => this.Load((JArray)server_params[0]));
            }));

            ServerService.instance.Socket.On("addStroke", new CustomListener((object[] server_params) =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    CustomStroke newStroke = SerializationHelper.stringToStroke((JObject)server_params[0], this.traits);
                    this.traits.Add(newStroke);
                    newStroke.Lock();
                });
            }));

            ServerService.instance.Socket.On("editStroke", new CustomListener((object[] server_params) =>
            {
                CustomStroke updated = SerializationHelper.stringToStroke((JObject)server_params[0], this.traits);
                Application.Current.Dispatcher.Invoke(() =>
                {
                    Stroke old = this.traits.get(updated.Id.ToString());
                    Console.WriteLine(((Savable)updated).toJson());
                    bool selected = ((CustomStroke)old).isSelected();
                    bool editting = ((CustomStroke)old).isEditing();
                    bool locked = ((CustomStroke)old).isLocked();
                    ((CustomStroke)old).stopEditing();
                    this.traits.Remove(this.traits.get(updated.Id.ToString()));

                    int newindex = this.traits.ToList().FindIndex(stroke => ((CustomStroke)stroke).Index > updated.Index);

                    try
                    {
                        this.traits.Insert(newindex, updated);
                    }
                    catch (ArgumentOutOfRangeException e)
                    {
                        this.traits.Add(updated);
                    }

                    if (selected) this.traits.get(updated.Id.ToString()).Select();
                    if (editting) this.traits.get(updated.Id.ToString()).startEditing();
                    if (locked) this.traits.get(updated.Id.ToString()).Lock();
                });
            }));

            ServerService.instance.Socket.On("removeStroke", new CustomListener((object[] server_params) =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    Stroke old = this.traits.ToList().Find(stroke => ((CustomStroke)stroke).Id.ToString() == (string)server_params[0]);
                    ((CustomStroke)old).stopEditing();
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        this.traits.Remove(old);
                    });
                });
            }));

            ServerService.instance.Socket.On("clearCanvas", new CustomListener((object[] server_params) =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    this.traits.Clear();
                });
            }));

            ServerService.instance.Socket.On("removeProtections", new CustomListener((object[] server_params) =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    Console.WriteLine(server_params[0]);
                    JArray toRemove = (JArray)server_params[0];
                    toRemove.ToList().ForEach(id =>
                    {
                        if (!this.traits.has((string)id)) return;

                        this.traits.get((string)id).Unselect();
                        this.traits.get((string)id).Unlock();
                    });
                });
            }));

            ServerService.instance.Socket.On("addProtections", new CustomListener((object[] server_params) =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    string holder = (string)server_params[0];
                    JArray toProtect = (JArray)server_params[1];
                    toProtect.ToList().ForEach(id =>
                    {
                        if (!this.traits.has((string)id)) return;

                        if (holder == ServerService.instance.user.username)
                        {

                            this.traits.get((string)id).Select();
                            if (this.waitingEdit == (string)id)
                            {
                                this.traits.get((string)id).startEditing();
                                this.EditingStroke = (string)id;
                                this.waitingEdit = null;
                            }
                        }
                        else
                            this.traits.get((string)id).Lock();
                    });
                });
            }));
        }

        public void Load(JArray shapeObjects)
        {
            traits.Clear();
            traitsRetires.Clear();
            
            for (int i = 0; i < shapeObjects.Count; i++)
            {
                this.traits.Add(SerializationHelper.stringToStroke((JObject)shapeObjects[i], this.traits));
            }
        }
    }
}