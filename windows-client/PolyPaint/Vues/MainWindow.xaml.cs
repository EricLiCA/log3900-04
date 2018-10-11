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
        private MessagingWindow MessagingWindow;

        public MainWindow()
        {
            this.FenetreDessin = new FenetreDessin();
            this.MessagingWindow = new MessagingWindow();
            this.Server_Connect();
            InitializeComponent();
            GridMain.Content = "Gallery";
        }
        private void Server_Connect()
        {
            LoginDialogBox dlg = new LoginDialogBox();
            if (dlg.ShowDialog() == false)
            {
                System.Environment.Exit(0);
            }  
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
                    GridMain.Content = this.MessagingWindow;
                    break;
                case 3:
                    GridMain.Content = this.FenetreDessin;
                    break;
            }
        }
    }
}
