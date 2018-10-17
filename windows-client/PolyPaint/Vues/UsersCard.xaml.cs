using MaterialDesignThemes.Wpf;
using PolyPaint.Modeles;
using System;
using System.Windows.Controls;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for UsersCard.xaml
    /// </summary>
    public partial class UsersCard : Card
    {
        public User User { get; set; }
        public UsersCard(User user)
        {
            InitializeComponent();
            User = user;
            DataContext = this;
        }

        public event EventHandler ViewButtonClicked;

        private void ViewButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            ViewButtonClicked?.Invoke(this, e);
        }
    }
}
