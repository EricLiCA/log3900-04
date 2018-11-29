using MaterialDesignThemes.Wpf;
using System;
using System.Windows.Media.Imaging;
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
            ConfigIcon();

            Uri imageUri = new Uri(image.fullImageUrl);
            BitmapImage imageBitmap = new BitmapImage();
            imageBitmap.BeginInit();
            imageBitmap.UriSource = imageUri;
            imageBitmap.CacheOption = BitmapCacheOption.OnLoad;
            imageBitmap.EndInit();

            this.ImagePlaceholder.Source = imageBitmap;
        }

        public event EventHandler ViewButtonClicked;

        private void ViewButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            ViewButtonClicked?.Invoke(this, e);
        }

        public void ConfigIcon()
        {
            IconContainer.Visibility = System.Windows.Visibility.Visible;
            IconContainer.ToolTip = Image.protectionLevel;
            if (Image.protectionLevel.Equals("private"))
            {
                Icon.Kind = PackIconKind.Lock;
            }
            else if (Image.protectionLevel.Equals("protected"))
            {
                Icon.Kind = PackIconKind.Key;
            }
            else
            {
                Icon.Kind = PackIconKind.Eye;
            }

        }
    }
}
