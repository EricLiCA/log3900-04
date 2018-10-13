using PolyPaint.VueModeles;
using System.Windows.Controls;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for MessagingWindow.xaml
    /// </summary>
    public partial class MessagingWindow : Page
    {
        
        public MessagingWindow()
        {
            DataContext = new MessagingViewModel();
            InitializeComponent();
        }

        private void SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ((MessagingViewModel)this.DataContext).OpenChat.Execute(Listfirst.SelectedIndex);
        }
    }
}
