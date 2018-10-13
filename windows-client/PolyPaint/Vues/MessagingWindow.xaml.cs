using MaterialDesignThemes.Wpf;
using PolyPaint.Modeles;
using PolyPaint.Services;
using PolyPaint.VueModeles;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

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
        
        internal void Initialize(Badged countingBadge)
        {
            if (countingBadge.Badge == null || Equals(countingBadge.Badge, ""))
                countingBadge.Badge = 1;
            else
                countingBadge.Badge = int.Parse(countingBadge.Badge.ToString()) + 1;
        }
    }
}
