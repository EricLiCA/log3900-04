using PolyPaint.Modeles;
using System.Windows.Controls;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for UsersCard.xaml
    /// </summary>
    public partial class UsersCard : Page
    {
        User User;
        public UsersCard(User user)
        {
            InitializeComponent();
            User = user;
        }
    }
}
