using System;
using System.Windows;
using System.Windows.Media;
using System.Windows.Controls.Primitives;
using PolyPaint.VueModeles;
using System.IO;
using System.Windows.Controls;
using PolyPaint.Modeles.Outils;
using System.Windows.Input;
using System.Windows.Forms;
using System.Linq;
using System.Windows.Ink;
using PolyPaint.Modeles;
using PolyPaint.Modeles.Strokes;
using System.Collections.Generic;
using PolyPaint.DAO;
using System.Windows.Media.Imaging;
using PolyPaint.Services;
using PolyPaint.Modeles.Actions;
using System.ComponentModel;

namespace PolyPaint
{
    /// <summary>
    /// Logique d'interaction pour FenetreDessin.xaml
    /// </summary>
    public partial class FenetreDessin : Page
    {

        public StrokeCollection ClipBoard { get; set; }
        public FenetreDessin()
        {
            InitializeComponent();
            DataContext = new VueModele();
            ClipBoard = new StrokeCollection();

            ((VueModele)DataContext).PropertyChanged += new PropertyChangedEventHandler(EditeurProprieteModifiee);
        }

        private void EditeurProprieteModifiee(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName == "CanvasSize")
            {
                colonne.Width = new GridLength(((VueModele)DataContext).CanvasWidth);
                ligne.Height = new GridLength(((VueModele)DataContext).CanvasHeight);
            }
        }

        // Pour gérer les points de contrôles.
        private void GlisserCommence(object sender, DragStartedEventArgs e) => (sender as Thumb).Background = Brushes.Black;
        private void GlisserTermine(object sender, DragCompletedEventArgs e)
        {
            (sender as Thumb).Background = Brushes.White;
            ((VueModele)DataContext).CanvasSize = new Size(colonne.ActualWidth, ligne.ActualHeight);
        }
        private void GlisserMouvementRecu(object sender, DragDeltaEventArgs e)
        {
            String nom = (sender as Thumb).Name;
            if (nom == "horizontal" || nom == "diagonal") colonne.Width = new GridLength(Math.Max(32, colonne.Width.Value + e.HorizontalChange));
            if (nom == "vertical" || nom == "diagonal") ligne.Height = new GridLength(Math.Max(32, ligne.Height.Value + e.VerticalChange));
        }

        // Pour la gestion de l'affichage de position du pointeur.
        private void Canvas_MouseLeave(object sender, System.Windows.Input.MouseEventArgs e) => textBlockPosition.Text = "";
        private void Canvas_MouseMove(object sender, System.Windows.Input.MouseEventArgs e)
        {
            Point p = e.GetPosition(Canvas);
            textBlockPosition.Text = Math.Round(p.X) + ", " + Math.Round(p.Y) + "px";
        }

        private void DupliquerSelection(object sender, RoutedEventArgs e)
        {
            VueModele vueModele = ((VueModele)this.DataContext);
            List<CustomStroke> selectedStrokes = vueModele.Traits.Where(stroke => ((CustomStroke)stroke).isSelected()).Cast<CustomStroke>().ToList();
            //If no stroke is selected ==> Cut/Paste operation
            if (selectedStrokes.Count == 0)
            {
                vueModele.Traits.Add(ClipBoard);
                ClipBoard.Clear();
            }
            else
            {
                vueModele.editeur.EditingStroke = null;
                selectedStrokes.ForEach(stroke =>
                {
                    CustomStroke duplicate = stroke.Duplicate();
                    ((VueModele)this.DataContext).Traits.Add(duplicate);
                    duplicate.Select();
                    EditionSocket.AddStroke(((Savable)duplicate).toJson());
                    Editeur.instance.Do(new NewStroke(((CustomStroke)duplicate).Id.ToString(), ((Savable)duplicate).toJson()));
                });
            }

        }

        private void SupprimerSelection(object sender, RoutedEventArgs e)
        {
            VueModele vueModele = ((VueModele)this.DataContext);
            vueModele.editeur.EditingStroke = null;
            var selectedStrokes = vueModele.Traits.Where(stroke => ((CustomStroke)stroke).isSelected()).ToList();
            if (selectedStrokes.Count > 0)
            {
                ClipBoard.Clear();
                selectedStrokes.ForEach(stroke =>
                {
                    vueModele.Traits.Remove(stroke);
                    ClipBoard.Add(stroke);
                    EditionSocket.RemoveStroke(((CustomStroke)stroke).Id.ToString());
                    Editeur.instance.Do(new DeleteStroke(((CustomStroke)stroke).Id.ToString(), ((Savable)stroke).toJson()));
                });
            }
        }


        private void Menu_Change_Avatar_Click(object sender, System.EventArgs e)
        {
            string fileName = null;

            using (OpenFileDialog openFileDialog1 = new OpenFileDialog())
            {
                openFileDialog1.InitialDirectory = "c:\\";
                openFileDialog1.Filter = "Image files (*.jpg, *.jpeg, *.jpe, *.jfif, *.png) | *.jpg; *.jpeg; *.jpe; *.jfif; *.png";
                openFileDialog1.FilterIndex = 2;
                openFileDialog1.RestoreDirectory = true;

                if (openFileDialog1.ShowDialog().ToString().Equals("OK"))
                {
                    fileName = openFileDialog1.FileName;
                }
            }

            if (fileName != null)
            {
                string text = File.ReadAllText(fileName);
            }
        }

        private void ChoisirOutil(object sender, SelectionChangedEventArgs e)
        {
            if (this.DataContext == null || this.ToolSelection.SelectedIndex == -1)
            {
                return;
            }

            ((VueModele)this.DataContext).ChoisirOutil.Execute((Tool)this.ToolSelection.SelectedItem);
        }

        private void Canvas_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            ((VueModele)this.DataContext).MouseUp.Execute(e.GetPosition((IInputElement)sender));
        }

        private void Canvas_PreviewMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            ((VueModele)this.DataContext).MouseDown.Execute(e.GetPosition((IInputElement)sender));
        }

        private void Canvas_PreviewMouseMove(object sender, System.Windows.Input.MouseEventArgs e)
        {
            ((VueModele)this.DataContext).MouseMove.Execute(e.GetPosition((IInputElement)sender));
        }

        private void Canvas_SelectionChanged(object sender, EventArgs e)
        {
            ((VueModele)this.DataContext).SelectStrokes.Execute(Canvas.GetSelectedStrokes());
            Canvas.Select(new StrokeCollection());
        }

        private void Canvas_PreviewMouseRightButtonUp(object sender, MouseButtonEventArgs e)
        {
            Point point = e.GetPosition((IInputElement)sender);
            CustomStroke clicked = null;
            Canvas.Strokes.ToList().ForEach(stroke =>
            {
                CustomStroke customStroke = (CustomStroke)stroke;
                if (!customStroke.isSelectable()) return;
                if (!customStroke.HitTest(point)) return;

                clicked = customStroke;
            });

            if (clicked != null)
            {
                ((VueModele)this.DataContext).Edit.Execute(clicked);
            }
        }

        private void Canvas_PreviewMouseWheel(object sender, MouseWheelEventArgs e)
        {
            Point point = e.GetPosition((IInputElement)sender);
            CustomStroke scrolled = null;
            Canvas.Strokes.ToList().ForEach(stroke =>
            {
                CustomStroke customStroke = (CustomStroke)stroke;
                if (!customStroke.isSelected()) return;
                if (!customStroke.HitTest(point)) return;

                scrolled = customStroke;
            });

            /* UNCOMMENT TO ENABLE ROTATING */
            //if (scrolled is ShapeStroke)
            //    ((ShapeStroke)scrolled).Rotation = ((ShapeStroke)scrolled).Rotation += e.Delta / 8.0;
        }

        public void SaveButton_Click(object sender, EventArgs e)
        {
            if (ServerService.instance.currentImageId == null) return;

            this.ToolSelection.SelectedIndex = 0;
            ((VueModele)this.DataContext).Traits.ToList().ForEach(temp =>
            {
                if (((CustomStroke)temp).isSelected()) ((CustomStroke)temp).Unselect();
            });

            Rect bounds = VisualTreeHelper.GetDescendantBounds(Canvas);
            double dpi = 96d;

            RenderTargetBitmap rtb = new RenderTargetBitmap(((VueModele)this.DataContext).CanvasWidth, ((VueModele)this.DataContext).CanvasHeight, dpi, dpi, PixelFormats.Default);
            DrawingVisual dv = new DrawingVisual();
            using (DrawingContext dc = dv.RenderOpen())
            {
                VisualBrush vb = new VisualBrush(Canvas);
                dc.DrawRectangle(vb, null, new Rect(new Point(), new Size(((VueModele)this.DataContext).CanvasWidth, ((VueModele)this.DataContext).CanvasHeight)));
            }
            rtb.Render(dv);

            BitmapEncoder pngEncoder = new PngBitmapEncoder();
            pngEncoder.Frames.Add(BitmapFrame.Create(rtb));
            using (MemoryStream ms = new MemoryStream())
            {
                pngEncoder.Save(ms);
                ((VueModele)this.DataContext).Save.Execute(ms.ToArray());
            }
        }

        private void Canvas_StrokeErasing(object sender, InkCanvasStrokeErasingEventArgs e)
        {
            VueModele vueModele = ((VueModele)this.DataContext);
            //Empiler la modification
            if (e.Stroke is Savable && !((CustomStroke)e.Stroke).isLocked())
            {
                CustomStroke erasedStroke = (CustomStroke)e.Stroke;
                vueModele.editeur.Do(new DeleteStroke(erasedStroke.Id.ToString(), ((Savable)erasedStroke).toJson()));
                EditionSocket.RemoveStroke(erasedStroke.Id.ToString());
            }
            else if (((CustomStroke)e.Stroke).isLocked())
            {
                e.Cancel = true;
            }
        }
    }
}
