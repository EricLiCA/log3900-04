using MaterialDesignThemes.Wpf;
using System;
using Image = PolyPaint.Modeles.Image;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for GalleryCard.xaml
    /// </summary>
    public partial class GalleryCard : Card
    {
        public Image Image { get; set; }

        public GalleryCard(Image image)
        {
            InitializeComponent();
            Image = image;
            DataContext = this;
        }

        public event EventHandler ViewButtonClicked;

        private void ViewButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            ViewButtonClicked?.Invoke(this, e);
        }
    }
}
