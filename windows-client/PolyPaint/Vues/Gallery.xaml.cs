using PolyPaint.DAO;
using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using Image = PolyPaint.Modeles.Image;


namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for Gallery.xaml
    /// </summary>
    public partial class Gallery : Page
    {
        private UIElementCollection GalleryCards;
        private ImageDao ImageDao;
        private int CurrentNumberOfImagesContainerChildren;
        public Image CurrentImage { get; set; }

        public Gallery()
        {
            InitializeComponent();
            ImageDao = new ImageDao();
            GalleryCards = new UIElementCollection(this.ImagesContainer, this.ImagesContainer);
            ImagesContainer.LayoutUpdated += OnImagesContainerUpdated;
            CurrentNumberOfImagesContainerChildren = 0;
            ImageView.Visibility = Visibility.Hidden;
            CurrentImage = new Image();
        }

        public void ChangeImageProtectionLevel_Click(string protectionLevel)
        {

        }

        public void CommentImage()
        {

        }

        public void LikeImage()
        {

        }

        public void Init()
        {
            ImageDao.GetAll(this.ImagesContainer);
        }


        private void ViewButton_Click(object sender, EventArgs e)
        {
            GalleryCard galleryCard = (GalleryCard)sender;
            CurrentImage = galleryCard.Image;
            ImageView.Visibility = Visibility.Visible;
            ImageView.IsExpanded = true;
            ImageViewTitle.Text = CurrentImage.Title;
        }

        private void OnImagesContainerUpdated(object sender, EventArgs e)
        {
            if (ImagesContainer?.Children?.Count > CurrentNumberOfImagesContainerChildren)
            {
                for (int i = CurrentNumberOfImagesContainerChildren; i < ImagesContainer.Children.Count; i++)
                {
                    GalleryCard galleryCard = (GalleryCard)ImagesContainer.Children[i];
                    galleryCard.ViewButtonClicked += ViewButton_Click;
                }
                CurrentNumberOfImagesContainerChildren = ImagesContainer.Children.Count;
            }
        }
    }
}
