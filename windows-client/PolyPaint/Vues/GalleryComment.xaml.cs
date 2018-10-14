using PolyPaint.Modeles;
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
    /// Interaction logic for GalleryComment.xaml
    /// </summary>
    public partial class GalleryComment : ContentControl
    {
        public ImageComment ImageComment { get; set; }
        public string UserName { get; set; }
        public GalleryComment(ImageComment imageComment)
        {
            InitializeComponent();
            ImageComment = imageComment;
            DataContext = this;
        }
    }
}
