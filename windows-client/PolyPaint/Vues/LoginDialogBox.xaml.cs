using System;
using System.Collections.Generic;
using System.Linq;
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
            this.DialogResult = true;
        }

        public string Email
        {
            get { return email.Text; }
        }

        public string Password
        {
            get { return password.Password; }
        }

        private void anonymous_Click(object sender, RoutedEventArgs e)
        {
            if (anonymous.IsChecked == true)
            {
                email.Visibility = Visibility.Collapsed;
                password.Visibility = Visibility.Collapsed;
                emailLabel.Visibility = Visibility.Collapsed;
                passwordLabel.Visibility = Visibility.Collapsed;
            }
            else
            {
                email.Visibility = Visibility.Visible;
                password.Visibility = Visibility.Visible;
                emailLabel.Visibility = Visibility.Visible;
                passwordLabel.Visibility = Visibility.Visible;
            }
        }
    }
}
