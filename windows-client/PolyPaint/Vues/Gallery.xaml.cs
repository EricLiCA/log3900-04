using Newtonsoft.Json.Linq;
using PolyPaint.DAO;
using PolyPaint.Modeles;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using RestSharp;
using System;
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
            ImageDao.GetAll();
        }

        public void LoadImages(IRestResponse response)
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
                        fullImageUrl = data["fullImageUrl"],
                    };

                    GalleryCard galleryCard = new GalleryCard(image);
                    galleryCard.ViewButtonClicked += ViewButton_Click;

                    if (image.ownerId == ServerService.instance.id && image.protectionLevel == "private")
                    {   
                        PrivateImagesContainer.Children.Add(galleryCard);
                    }
                    else if (image.protectionLevel != "private")
                    {
                        PublicImagesContainer.Children.Add(galleryCard);
                    }

                }
            }
            else
            {
                MessageBox.Show("Could not load the images", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public void LoadCurrentImageLikes(IRestResponse response)
        {
            LikeButton.IsChecked = false;
            if (response.StatusCode == HttpStatusCode.OK)
            {
                JArray responseImageLikes = JArray.Parse(response.Content);
                for (int i = 0; i < responseImageLikes.Count; i++)
                {
                    dynamic data = JObject.Parse(responseImageLikes[i].ToString());
                    if (data["userId"] == ServerService.instance.id)
                    {
                        LikeButton.IsChecked = true;
                    }
                }
                ImageViewLikes.Text = responseImageLikes.Count.ToString();
            }
            else
            {
                ImageViewLikes.Text = "0";
            }
            SetToggleButtonTooltip(LikeButton, Settings.LIKE_BUTTON_CHECKED_TOOLTIP, Settings.LIKE_BUTTON_UNCHECKED_TOOLTIP);
        }

        public void LoadCurrentImageComments(IRestResponse response)
        {
            CommentsContainer.Children.Clear();
            if (response.StatusCode == HttpStatusCode.OK)
            {
                JArray responseImageComments = JArray.Parse(response.Content);
                for (int i = 0; i < responseImageComments.Count; i++)
                {
                    dynamic data = JObject.Parse(responseImageComments[i].ToString());
                    ImageComment imageComment = new ImageComment
                    {
                        imageId = data["imageId"],
                        userId = data["userId"],
                        comment = data["comment"],
                        timestamp = data["timestamp"],
                        userName = data["userName"]
                    };
                    GalleryComment galleryComment = new GalleryComment(imageComment);
                    CommentsContainer.Children.Add(galleryComment);
                }
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
            ImageLikeDao.Get(CurrentGalleryCard.Image.id);
            ImageCommentDao.Get(CurrentGalleryCard.Image.id);

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
            ImageDao.Put(CurrentGalleryCard.Image);
            ConfigImageViewButtons();

        }

        private void LikeButton_Click(object sender, RoutedEventArgs e)
        {
            ImageLike imageLike = new ImageLike
            {
                imageId = CurrentGalleryCard.Image.id,
                userId = ServerService.instance.id
            };
            if ((bool)LikeButton.IsChecked)
            {
                ImageLikeDao.Post(imageLike);
                try
                {
                    ImageViewLikes.Text = (System.Convert.ToInt32(ImageViewLikes.Text) + 1).ToString();
                }
                catch (FormatException)
                {
                    Console.WriteLine("Cannot convert string to int");
                }

            } else
            {
                ImageLikeDao.Delete(imageLike);
                try
                {
                    ImageViewLikes.Text = (System.Convert.ToInt32(ImageViewLikes.Text) -1).ToString();
                }
                catch (FormatException)
                {
                    Console.WriteLine("Cannot convert string to int");
                }
            }
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

        private void AddCommentButton_Click(object sender, RoutedEventArgs e)
        {
            ImageComment imageComment = new ImageComment
            {
                userId = ServerService.instance.id,
                imageId = CurrentGalleryCard.Image.id,
                comment = CurrentComment.Text,
                userName = ServerService.instance.username,
                timestamp = DateTime.Now
            };
            ImageCommentDao.Post(imageComment);
            GalleryComment galleryComment = new GalleryComment(imageComment);
            CommentsContainer.Children.Insert(0, galleryComment);
        }

        #region AddPassword/RemovePassword Dialog

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

        private void AddPasswordButton_Click(object sender, RoutedEventArgs e)
        {
            CurrentGalleryCard.Image.password = CurrentImagePassword.Text;
            CurrentGalleryCard.Image.protectionLevel = "protected";
            ImageDao.Put(CurrentGalleryCard.Image);
            AddPasswordButton.IsEnabled = false;
        }

        private void RemovePasswordButton_Click(object sender, RoutedEventArgs e)
        {
            CurrentGalleryCard.Image.password = null;
            CurrentGalleryCard.Image.protectionLevel = "public";
            CurrentImagePassword.Text = null;
            ImageDao.Put(CurrentGalleryCard.Image);
            AddPasswordButton.IsEnabled = false;
        }

        private void CloseDialogButton_Click(object sender, RoutedEventArgs e)
        {
            CurrentImagePassword.Text = CurrentGalleryCard.Image.password;
            AddPasswordButton.IsEnabled = false;
        }
        #endregion
    }
}
