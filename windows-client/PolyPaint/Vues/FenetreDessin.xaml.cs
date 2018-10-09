using System;
using System.Windows;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Controls.Primitives;
using System.Windows.Forms;
using PolyPaint.VueModeles;
using PolyPaint.Vues;
using System.Net;
using System.IO;
using System.Windows.Controls;

namespace PolyPaint
{
    /// <summary>
    /// Logique d'interaction pour FenetreDessin.xaml
    /// </summary>
    public partial class FenetreDessin : Window
    {

        private Chat ChatView;

        public FenetreDessin()
        {
            InitializeComponent();
            DataContext = new VueModele();
        }
        
        // Pour gérer les points de contrôles.
        private void GlisserCommence(object sender, DragStartedEventArgs e) => (sender as Thumb).Background = Brushes.Black;
        private void GlisserTermine(object sender, DragCompletedEventArgs e) => (sender as Thumb).Background = Brushes.White;
        private void GlisserMouvementRecu(object sender, DragDeltaEventArgs e)
        {
            String nom = (sender as Thumb).Name;
            if (nom == "horizontal" || nom == "diagonal") colonne.Width = new GridLength(Math.Max(32, colonne.Width.Value + e.HorizontalChange));
            if (nom == "vertical" || nom == "diagonal") ligne.Height = new GridLength(Math.Max(32, ligne.Height.Value + e.VerticalChange));
        }

        // Pour la gestion de l'affichage de position du pointeur.
        private void surfaceDessin_MouseLeave(object sender, System.Windows.Input.MouseEventArgs e) => textBlockPosition.Text = "";
        private void surfaceDessin_MouseMove(object sender, System.Windows.Input.MouseEventArgs e)
        {
            Point p = e.GetPosition(surfaceDessin);
            textBlockPosition.Text = Math.Round(p.X) + ", " + Math.Round(p.Y) + "px";
        }

        private void DupliquerSelection(object sender, RoutedEventArgs e)
        {          
            surfaceDessin.CopySelection();
            surfaceDessin.Paste();
        }

        private void SupprimerSelection(object sender, RoutedEventArgs e) => surfaceDessin.CutSelection();

        private void Menu_Connect_Click(object sender, RoutedEventArgs e)
        {
            LoginDialogBox dlg = new LoginDialogBox();
            if (dlg.ShowDialog() == true)
            {
                var url = string.Format(dlg.IP.StartsWith("http") ? "{0}" : "http://{0}", dlg.IP);
                var httpWebRequest = (HttpWebRequest)WebRequest.Create(string.Format("{0}/v1/status/", url));

                httpWebRequest.ContentType = "text/html";
                httpWebRequest.Method = "GET";

                var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    var result = streamReader.ReadToEnd();
                    if (result != "log3900-server")
                    {
                        return;
                    }
                }

                if (this.ChatView == null)
                {
                    this.ChatView = new Chat(this, url, dlg.Username);
                } else
                {
                    this.ChatView.Connect(url, dlg.Username);
                }
                this.Chat_Reserved_Zone.Visibility = Visibility.Visible;
                Chat_Docker.Content = this.ChatView;

                this.Menu_Disconnect.Visibility = Visibility.Visible;
                this.Menu_Connect.Visibility = Visibility.Collapsed;
                this.Menu_Change_Avatar.Visibility = Visibility.Visible;
            };
        }

        internal void Menu_Disconnect_Click(object sender, RoutedEventArgs e)
        {
            this.ChatView.Disconnect();

            this.Chat_Reserved_Zone.Visibility = Visibility.Collapsed;
            this.Menu_Disconnect.Visibility = Visibility.Collapsed;
            this.Menu_Connect.Visibility = Visibility.Visible;
            this.Menu_Change_Avatar.Visibility = Visibility.Collapsed;
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
            if (this.DataContext == null)
            {
                return;
            }

            Console.WriteLine(((ListBoxItem)this.ToolSelection.SelectedItem).Name);
            ((VueModele)this.DataContext).ChoisirOutil.Execute(((ListBoxItem)this.ToolSelection.SelectedItem).Name);
        }
    }
}
