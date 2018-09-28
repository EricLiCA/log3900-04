using System;
using System.Windows;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Controls.Primitives;
using PolyPaint.VueModeles;
using PolyPaint.Vues;
using System.Net;
using System.IO;

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
        private void surfaceDessin_MouseLeave(object sender, MouseEventArgs e) => textBlockPosition.Text = "";
        private void surfaceDessin_MouseMove(object sender, MouseEventArgs e)
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
                var protocolProvided = dlg.IP.StartsWith("http");
                var url = string.Format(protocolProvided ? "{0}" : "http://{0}", dlg.IP);
                var httpWebRequest = (HttpWebRequest)WebRequest.Create(string.Format("{0}/api/status/", url));
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
            };
        }

        internal void Menu_Disconnect_Click(object sender, RoutedEventArgs e)
        {
            this.ChatView.Disconnect();

            this.Chat_Reserved_Zone.Visibility = Visibility.Collapsed;
            this.Menu_Disconnect.Visibility = Visibility.Collapsed;
            this.Menu_Connect.Visibility = Visibility.Visible;
        }
    }
}
