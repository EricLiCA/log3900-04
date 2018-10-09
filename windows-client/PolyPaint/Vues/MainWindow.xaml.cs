using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private FenetreDessin FenetreDessin;

        public MainWindow()
        {
            this.FenetreDessin = new FenetreDessin();
            this.Server_Connect();
            InitializeComponent();
        }
        private void Server_Connect()
        {
            LoginDialogBox dlg = new LoginDialogBox();
            if (dlg.ShowDialog() == true)
            {
                var url = string.Format(dlg.IP.StartsWith("http") ? "{0}" : "http://{0}", dlg.IP);
                var httpWebRequest = (HttpWebRequest)WebRequest.Create(string.Format("{0}/v1/status/", url));

                var client = new RestClient(url);
                var request = new RestRequest("v1/status", Method.GET);
                IRestResponse response = client.Execute(request);
                if (response.Content != "log3900-server") return;
            };
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            int index = int.Parse(((Button)e.Source).Uid);

            GridCursor.Margin = new Thickness(10 + (150 * index), 0, 0, 0);

            switch (index)
            {
                case 0:
                    GridMain.Content = "Gallery";
                    break;
                case 1:
                    GridMain.Content = "Users";
                    break;
                case 2:
                    GridMain.Content = "Chat";
                    break;
                case 3:
                    GridMain.Content = this.FenetreDessin;
                    break;
            }
        }
    }
}
