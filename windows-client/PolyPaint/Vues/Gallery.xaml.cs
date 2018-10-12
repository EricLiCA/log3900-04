using MaterialDesignThemes.Wpf;
using PolyPaint.DAO;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using Image = PolyPaint.Modeles.Image;




namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for Gallery.xaml
    /// </summary>
    public partial class Gallery : Page
    {
        private UIElementCollection GalleryCards;
        private int CurrentNumberOfImagesContainerChildren;
        public Image CurrentImage { get; set; }

        public Gallery()
        {
            InitializeComponent();
            GalleryCards = new UIElementCollection(this.ImagesContainer, this.ImagesContainer);
            ImagesContainer.LayoutUpdated += OnImagesContainerUpdated;
            CurrentNumberOfImagesContainerChildren = 0;
            ImageView.Visibility = Visibility.Hidden;
            CurrentImage = new Image();
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
            ImageViewTitle.Text = CurrentImage.title;
            Uri imageUri = new Uri(CurrentImage.fullImageUrl);
            BitmapImage imageBitmap = new BitmapImage(imageUri);
            ImageViewPicture.Source = imageBitmap;

            if (CurrentImage.ownerId == ServerService.instance.id)
            {
                LikeButton.IsEnabled = false;
                PasswordButton.Visibility = Visibility.Visible;
                LockButton.Visibility = Visibility.Visible;
            } else
            {
                LikeButton.IsEnabled = true;
                PasswordButton.Visibility = Visibility.Hidden;
                LockButton.Visibility = Visibility.Hidden;
            }
            SetImageViewButtons();
        }

        private void AddPassword_Button(object sender, RoutedEventArgs e)
        {
            CurrentImage.password = CurrentImagePassword.Password;
            CurrentImage.protectionLevel = "protected";
            ImageDao.Update(CurrentImage);
            SetImageViewButtons();
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

        private void SetImageViewButtons()
        {
            switch (CurrentImage.protectionLevel)
            {
                case "public":
                    {
                        LockButton.IsChecked = false;
                        PasswordButton.IsChecked = false;
                        PasswordButton.IsEnabled = true;
                        break;
                    }
                case "private":
                    {
                        LockButton.IsChecked = true;
                        PasswordButton.IsChecked = false;
                        PasswordButton.IsEnabled = false;
                        break;
                    }
                case "protected":
                    {
                        LockButton.IsChecked = false;
                        PasswordButton.IsEnabled = true;
                        PasswordButton.IsChecked = true;
                        break;
                    }
            }
            SetToggleButtonTooltip(LockButton, Settings.LOCK_BUTTON_CHECKED_TOOLTIP, Settings.LOCK_BUTTON_UNCHECKED_TOOLTIP);
            SetToggleButtonTooltip(PasswordButton, Settings.PASSWORD_BUTTON_CHECKED_TOOLTIP, Settings.PASSWORD_BUTTON_UNCHECKED_TOOLTIP);
        }
        private void PasswordButton_Click(object sender, RoutedEventArgs e)
        {
            zeb.IsOpen = true;
        }

        private void LockButton_Click(object sender, RoutedEventArgs e)
        {
            CurrentImage.protectionLevel = ((bool)LockButton.IsChecked) ? "private" : "public";
            ImageDao.Update(CurrentImage);
            SetImageViewButtons();
        }

        private void LikeButton_Click(object sender, RoutedEventArgs e)
        {
            SetToggleButtonTooltip(LikeButton, Settings.LIKE_BUTTON_CHECKED_TOOLTIP, Settings.LIKE_BUTTON_UNCHECKED_TOOLTIP);
        }

        private void SetToggleButtonTooltip(ToggleButton  toggleButton, string checkedMessage, string uncheckedMessage)
        {
            ToolTip toolTip = new ToolTip
            {
                Content = ((bool)toggleButton.IsChecked) ? checkedMessage : uncheckedMessage
            };
            toggleButton.ToolTip = toolTip;
        }
    }
}
