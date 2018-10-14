using MaterialDesignThemes.Wpf;
using Newtonsoft.Json.Linq;
using PolyPaint.DAO;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Net;
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
        public GalleryCard CurrentGalleryCard { get; set; }

        public Gallery()
        {
            InitializeComponent();
            ImageView.Visibility = Visibility.Hidden;
            CurrentGalleryCard = new GalleryCard(null);
        }

        public void Init()
        {
            ImageDao.GetAll();
        }

        public void FillWithImages(IRestResponse response)
        {
            if (response.StatusCode == HttpStatusCode.OK)
            {
                PrivateImagesContainer.Children.Clear();
                PublicImagesContainer.Children.Clear();
                JArray responseImages = JArray.Parse(response.Content);
                for (int i = 0; i < responseImages.Count; i++)
                {
                    dynamic data = JObject.Parse(responseImages[i].ToString());
                    Image image = new Image
                    {
                        id = data["id"],
                        ownerId = data["ownerId"],
                        title = data["title"],
                        protectionLevel = data["protectionLevel"],
                        password = data["password"],
                        thumbnailUrl = data["thumbnailUrl"],
                        fullImageUrl = data["fullImageUrl"]
                    };
                    GalleryCard galleryCard = new GalleryCard(image);
                    if (image.ownerId == ServerService.instance.id && image.protectionLevel == "private")
                    {
                        PrivateImagesContainer.Children.Add(galleryCard);
                        galleryCard.ViewButtonClicked += ViewButton_Click;
                    }
                    else if (image.protectionLevel != "private")
                    {
                        PublicImagesContainer.Children.Add(galleryCard);
                        galleryCard.ViewButtonClicked += ViewButton_Click;
                    }
                }
            }
            else
            {
                MessageBox.Show("Could not load the images", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }


        private void ViewButton_Click(object sender, EventArgs e)
        {
            GalleryCard galleryCard = (GalleryCard)sender;
            CurrentGalleryCard = galleryCard;
            ImageView.Visibility = Visibility.Visible;
            ImageView.IsExpanded = true;
            ImageViewTitle.Text = CurrentGalleryCard.Image.title;
            CurrentImagePassword.Text = CurrentGalleryCard.Image.password;
            Uri imageUri = new Uri(CurrentGalleryCard.Image.fullImageUrl);
            BitmapImage imageBitmap = new BitmapImage(imageUri);
            ImageViewPicture.Source = imageBitmap;

            if (CurrentGalleryCard.Image.ownerId == ServerService.instance.id)
            {
                LikeButton.IsEnabled = false;
                PasswordButton.Visibility = Visibility.Visible;
                LockButton.Visibility = Visibility.Visible;
            }
            else
            {
                LikeButton.IsEnabled = true;
                PasswordButton.Visibility = Visibility.Hidden;
                LockButton.Visibility = Visibility.Hidden;
            }
            ConfigImageViewButtons();
        }

        private void AddPasswordButton_Click(object sender, RoutedEventArgs e)
        {
            CurrentGalleryCard.Image.password = CurrentImagePassword.Text;
            CurrentGalleryCard.Image.protectionLevel = "protected";
            ImageDao.Update(CurrentGalleryCard.Image);
            AddPasswordButton.IsEnabled = false;
        }
        private void RemovePasswordButton_Click(object sender, RoutedEventArgs e)
        {
            CurrentGalleryCard.Image.password = null;
            CurrentGalleryCard.Image.protectionLevel = "public";
            CurrentImagePassword.Text = null;
            ImageDao.Update(CurrentGalleryCard.Image);
            AddPasswordButton.IsEnabled = false;
        }
        private void CloseDialogButton_Click(object sender, RoutedEventArgs e)
        {
            CurrentImagePassword.Text = CurrentGalleryCard.Image.password;
            AddPasswordButton.IsEnabled = false;
        }

        private void ConfigImageViewButtons()
        {
            switch (CurrentGalleryCard.Image.protectionLevel)
            {
                case "public":
                    {
                        LockButton.IsChecked = false;
                        PasswordButton.IsEnabled = true;
                        break;
                    }
                case "private":
                    {
                        LockButton.IsChecked = true;
                        PasswordButton.IsEnabled = false;
                        break;
                    }
                case "protected":
                    {
                        LockButton.IsChecked = false;
                        PasswordButton.IsEnabled = true;
                        break;
                    }
            }
            SetToggleButtonTooltip(LockButton, Settings.LOCK_BUTTON_CHECKED_TOOLTIP, Settings.LOCK_BUTTON_UNCHECKED_TOOLTIP);
        }

        private void LockButton_Click(object sender, RoutedEventArgs e)
        {
            if ((bool)LockButton.IsChecked)
            {
                CurrentGalleryCard.Image.protectionLevel = "private";
                PublicImagesContainer.Children.Remove(CurrentGalleryCard);
                PrivateImagesContainer.Children.Add(CurrentGalleryCard);
            } else
            {
                CurrentGalleryCard.Image.protectionLevel = "public";
                PrivateImagesContainer.Children.Remove(CurrentGalleryCard);
                PublicImagesContainer.Children.Add(CurrentGalleryCard);
            }
            ImageDao.Update(CurrentGalleryCard.Image);
            ConfigImageViewButtons();

        }

        private void LikeButton_Click(object sender, RoutedEventArgs e)
        {
            SetToggleButtonTooltip(LikeButton, Settings.LIKE_BUTTON_CHECKED_TOOLTIP, Settings.LIKE_BUTTON_UNCHECKED_TOOLTIP);
        }

        private void SetToggleButtonTooltip(ToggleButton toggleButton, string checkedMessage, string uncheckedMessage)
        {
            ToolTip toolTip = new ToolTip
            {
                Content = ((bool)toggleButton.IsChecked) ? checkedMessage : uncheckedMessage
            };
            toggleButton.ToolTip = toolTip;
        }

        private void CurrentImagePassword_KeyUp(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (CurrentImagePassword.Text.Length == 0 || CurrentImagePassword.Text.Contains(" "))
            {
                AddPasswordButton.IsEnabled = false;
            }
            else
            {
                AddPasswordButton.IsEnabled = true;
            }
        }
    }
}
