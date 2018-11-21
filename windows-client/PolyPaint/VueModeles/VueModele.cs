using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Ink;
using System.Windows.Media;
using PolyPaint.Modeles;
using PolyPaint.Modeles.Outils;
using PolyPaint.Modeles.Strokes;
using PolyPaint.Utilitaires;
using PolyPaint.Vues;

namespace PolyPaint.VueModeles
{

    /// <summary>
    /// Sert d'intermédiaire entre la vue et le modèle.
    /// Expose des commandes et propriétés connectées au modèle aux des éléments de la vue peuvent se lier.
    /// Reçoit des avis de changement du modèle et envoie des avis de changements à la vue.
    /// </summary>
    public class VueModele : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        public Editeur editeur = new Editeur();

        private Page lineEditor;
        private Page classEditor;

        // Ensemble d'attributs qui définissent l'apparence d'un trait.
        public DrawingAttributes AttributsDessin { get; set; } = new DrawingAttributes();
        public List<Tool> Tools { get => this.editeur.Tools; }

        public Tool OutilSelectionne
        {
            get { return editeur.OutilSelectionne; }            
            set { ProprieteModifiee(); }
        }

        public string ActiveItemTextContent
        {
            get => editeur.ActiveItemTextContent;
            set => editeur.ActiveItemTextContent = value;
        }

        public string FirstLabel
        {
            get => editeur.FirstLabel;
            set => editeur.FirstLabel = value;
        }

        public string SecondLabel
        {
            get => editeur.SecondLabel;
            set => editeur.SecondLabel = value;
        }

        public Relation FirstRelation
        {
            get => editeur.FirstRelation;
            set => editeur.FirstRelation = value;
        }

        public Relation SecondRelation
        {
            get => editeur.SecondRelation;
            set => editeur.SecondRelation = value;
        }

        public string CouleurSelectionnee
        {
            get { return editeur.CouleurSelectionnee; }
            set { editeur.CouleurSelectionnee = value; }
        }

        public int TailleTrait
        {
            get { return editeur.TailleTrait; }
            set { editeur.TailleTrait = value; }
        }
        
        public Size CanvasSize
        {
            get => editeur.CanvasSize;
            set => editeur.CanvasSize = value;
        }

        public int CanvasWidth { get => (int)editeur.CanvasSize.Width; }
        public int CanvasHeight { get => (int)editeur.CanvasSize.Height; }

        public Page EditingFrameContent
        {
            get
            {
                if (!this.editeur.traits.has(this.editeur.EditingStroke)) return null;
                CustomStroke stroke = this.editeur.traits.get(this.editeur.EditingStroke);

                if (stroke is BaseLine)
                    return this.lineEditor;

                if (stroke is Textable)
                    return this.classEditor;

                return null;
            }
        }

        public StrokeCollection Traits { get; set; }

        // Commandes sur lesquels la vue pourra se connecter.
        public RelayCommand<object> Undo { get; set; }
        public RelayCommand<object> Redo { get; set; }
        public RelayCommand<Tool> ChoisirOutil { get; set; }
        public RelayCommand<object> Reinitialiser { get; set; }
        public RelayCommand<Point> MouseUp { get; set; }
        public RelayCommand<byte[]> Save { get; set; }
        public RelayCommand<Point> MouseDown { get; set; }
        public RelayCommand<Point> MouseMove { get; set; }
        public RelayCommand<StrokeCollection> SelectStrokes { get; set; }
        public RelayCommand<CustomStroke> Edit { get; set; }
        public RelayCommand<string> ChangeClassContent { get; set; }

        /// <summary>
        /// Constructeur de VueModele
        /// On récupère certaines données initiales du modèle et on construit les commandes
        /// sur lesquelles la vue se connectera.
        /// </summary>
        public VueModele()
        {
            // On écoute pour des changements sur le modèle. Lorsqu'il y en a, EditeurProprieteModifiee est appelée.
            editeur.PropertyChanged += new PropertyChangedEventHandler(EditeurProprieteModifiee);

            this.lineEditor = new LineEdit(this);
            this.classEditor = new ClassEdit(this);

            // On initialise les attributs de dessin avec les valeurs de départ du modèle.
            AttributsDessin = new DrawingAttributes();            
            AttributsDessin.Color = (Color)ColorConverter.ConvertFromString(editeur.CouleurSelectionnee);
            Traits = editeur.traits;
            
            // Pour chaque commande, on effectue la liaison avec des méthodes du modèle.            
            Undo = new RelayCommand<object>(editeur.Undo, editeur.PeutUndo);            
            Redo = new RelayCommand<object>(editeur.Redo, editeur.PeutRedo);
            Save = new RelayCommand<byte[]>(editeur.Save);
            // Pour les commandes suivantes, il est toujours possible des les activer.
            // Donc, aucune vérification de type Peut"Action" à faire.
            ChoisirOutil = new RelayCommand<Tool>(editeur.ChoisirOutil);
            Reinitialiser = new RelayCommand<object>(editeur.Reinitialiser);

            MouseUp = new RelayCommand<Point>(editeur.MouseUp);
            MouseDown = new RelayCommand<Point>(editeur.MouseDown);
            MouseMove = new RelayCommand<Point>(editeur.MouseMove);
            SelectStrokes = new RelayCommand<StrokeCollection>(editeur.SelectStrokes);
            Edit = new RelayCommand<CustomStroke>(editeur.Edit);
        }

        /// <summary>
        /// Appelee lorsqu'une propriété de VueModele est modifiée.
        /// Un évènement indiquant qu'une propriété a été modifiée est alors émis à partir de VueModèle.
        /// L'évènement qui contient le nom de la propriété modifiée sera attrapé par la vue qui pourra
        /// alors mettre à jour les composants concernés.
        /// </summary>
        /// <param name="propertyName">Nom de la propriété modifiée.</param>
        protected virtual void ProprieteModifiee([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        /// <summary>
        /// Traite les évènements de modifications de propriétés qui ont été lancés à partir
        /// du modèle.
        /// </summary>
        /// <param name="sender">L'émetteur de l'évènement (le modèle)</param>
        /// <param name="e">Les paramètres de l'évènement. PropertyName est celui qui nous intéresse. 
        /// Il indique quelle propriété a été modifiée dans le modèle.</param>
        private void EditeurProprieteModifiee(object sender, PropertyChangedEventArgs e)
        {     
            if (e.PropertyName == "CouleurSelectionnee")
            {
                AttributsDessin.Color = (Color)ColorConverter.ConvertFromString(editeur.CouleurSelectionnee);
            }
            else if (e.PropertyName == "OutilSelectionne")
            {
                OutilSelectionne = editeur.OutilSelectionne;
            }
            else if (e.PropertyName == "ActiveItemTextContent")
            {
                this.ProprieteModifiee("ActiveItemTextContent");
            }
            else if (e.PropertyName == "FirstLabel")
            {
                this.ProprieteModifiee("FirstLabel");
            }
            else if (e.PropertyName == "SecondLabel")
            {
                this.ProprieteModifiee("SecondLabel");
            }
            else if (e.PropertyName == "FirstRelation")
            {
                this.ProprieteModifiee("FirstRelation");
            }
            else if (e.PropertyName == "SecondRelation")
            {
                this.ProprieteModifiee("SecondRelation");
            }
            else if (e.PropertyName == "EditingStroke")
            {
                this.ProprieteModifiee("EditingFrameContent");
            }
            else if (e.PropertyName == "CanvasSize")
            {
                this.ProprieteModifiee("CanvasSize");
            }
        }
    }
}
