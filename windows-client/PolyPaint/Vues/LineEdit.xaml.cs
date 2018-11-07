using PolyPaint.Modeles.Strokes;
using PolyPaint.VueModeles;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for LineEdit.xaml
    /// </summary>
    public partial class LineEdit : Page
    {
        public LineEdit(VueModele vueModele)
        {
            this.DataContext = vueModele;
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Relation tempRelation = ((VueModele)DataContext).FirstRelation;
            ((VueModele)DataContext).FirstRelation = ((VueModele)DataContext).SecondRelation;
            ((VueModele)DataContext).SecondRelation = tempRelation;

            string tempLabel = ((VueModele)DataContext).FirstLabel;
            ((VueModele)DataContext).FirstLabel = ((VueModele)DataContext).SecondLabel;
            ((VueModele)DataContext).SecondLabel = tempLabel;
        }
    }
}
