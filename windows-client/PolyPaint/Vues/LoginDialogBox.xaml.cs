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
    /// Interaction logic for LoginDialogBox.xaml
    /// </summary>
    public partial class LoginDialogBox : Window
    {
        public LoginDialogBox()
        {
            InitializeComponent();
        }

        private void Connect_Click(object sender, RoutedEventArgs e)
        {
            progress.Visibility = Visibility.Visible;
            Verify_Server();
        }

        public string IP
        {
            get { return ip.Text; }
        }

        public bool Anonymous
        {
            get { return (bool)anonymous.IsChecked; }
        }

        public string Password
        {
            get { return password.Password; }
        }

        public string Username
        {
            get { return username.Text; }
        }

        private void CheckBox_Checked(object sender, RoutedEventArgs e)
        {
            password.IsEnabled = !(bool)anonymous.IsChecked;
        }

        private void Verify_Server()
        {
            var url = string.Format(IP.StartsWith("http") ? "{0}" : "http://{0}", IP);
            var httpWebRequest = (HttpWebRequest)WebRequest.Create(string.Format("{0}/v1/status/", url));

            var client = new RestClient(url);
            var request = new RestRequest("v1/status", Method.GET);
            client.ExecuteAsync(request, response =>
            {
                this.Dispatcher.Invoke(() =>
                {
                    if (response.Content == "log3900-server")
                    {
                        DialogResult = true;
                    }
                    else
                    {
                        progress.Visibility = Visibility.Collapsed;
                        MessageBox.Show("Wrong credentials", "Error", MessageBoxButton.OK, MessageBoxImage.Warning);
                    }
                });
            });
        }
    }
}
