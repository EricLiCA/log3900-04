using Newtonsoft.Json.Linq;
using PolyPaint.DAO;
using PolyPaint.Modeles;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
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
        public ImagePreviewRoom ImagePreviewRoom { get; set; }

        public Gallery()
        {
            InitializeComponent();
            ImageView.Visibility = Visibility.Hidden;
            ImagePreviewRoom = new ImagePreviewRoom(CommentsContainer);
            DataContext = this;
            Load();
        }

        public void Load()
        {
            if (ServerService.instance.isOffline())
                RestrictPermissions();

            ImageDao.GetByOwnerId();
            ImageDao.GetPublicExceptMine();
        }

        private void RestrictPermissions()
        {
            LikeButton.IsEnabled = false;
            CurrentComment.IsEnabled = false;
            AddCommentButton.IsEnabled = false;
            ShareButton.IsEnabled = false;
        }

        public void LoadMyImages(string response)
        {
            MyImagesContainer.Children.Clear();
            JArray responseImages = JArray.Parse(response);
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
                    thumbnailUrl = ServerService.instance.isOffline() ? data["thumbnailUrl"] : Settings.URL_TO_GALLERY_IMAGES + data["id"] + ".png",
                    fullImageUrl = ServerService.instance.isOffline() ? data["thumbnailUrl"] : Settings.URL_TO_GALLERY_IMAGES + data["id"] + ".png",
                    authorName = data["authorName"]
                };


                GalleryCard galleryCard = new GalleryCard(image);
                galleryCard.ViewButtonClicked += ViewButton_Click;
                MyImagesContainer.Children.Add(galleryCard);
            }
        }

        public void LoadPublicImages(IRestResponse response)
        {
            if (response.StatusCode == HttpStatusCode.OK)
            {
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
                        thumbnailUrl = Settings.URL_TO_GALLERY_IMAGES + data["id"] + ".png",
                        fullImageUrl = Settings.URL_TO_GALLERY_IMAGES + data["id"] + ".png",
                        authorName = data["authorName"]
                    };

                    GalleryCard galleryCard = new GalleryCard(image);
                    galleryCard.ViewButtonClicked += ViewButton_Click;
                    PublicImagesContainer.Children.Add(galleryCard);
                }
            }
            else
            {
                MessageBox.Show("Could not load the images", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public void CheckOrUncheckLikeButton()
        {
            LikeButton.IsChecked = false;
            for (int i = 0; i < ImagePreviewRoom.Likes.Count; i++)
            {
                if (ImagePreviewRoom.Likes[i].userId == ServerService.instance.user.id)
                {
                    LikeButton.IsChecked = true;
                }
            }
        }

        private void ViewButton_Click(object sender, EventArgs e)
        {

            CurrentGalleryCard = (GalleryCard)sender;
            ImageView.Visibility = Visibility.Visible;
            ImageView.IsExpanded = true;
            ImageViewTitle.Text = CurrentGalleryCard.Image.title;
            ImageViewAuthor.Text = "CreatedBy " + CurrentGalleryCard.Image.authorName;
            CurrentImagePassword.Text = CurrentGalleryCard.Image.password;
            Uri imageUri = new Uri(CurrentGalleryCard.Image.fullImageUrl);
            BitmapImage imageBitmap = new BitmapImage();
            imageBitmap.BeginInit();
            imageBitmap.UriSource = imageUri;
            imageBitmap.CacheOption = BitmapCacheOption.OnLoad;
            imageBitmap.EndInit();
            ImageViewPicture.Source = imageBitmap;

            ImagePreviewRoom.ImageId = CurrentGalleryCard.Image.id;
            ImagePreviewRoom.PreviewImage();
            
           
            if (!ServerService.instance.isOffline())
            {
                ShareButton.Visibility = CurrentGalleryCard.Image.ownerId == ServerService.instance.user.id ? Visibility.Visible : Visibility.Collapsed;
                if (CurrentGalleryCard.Image.ownerId == ServerService.instance.user.id)
                {
                    LikeButton.IsEnabled = false;
                    ImageInformationsButton.Visibility = Visibility.Visible;
                    LockButton.Visibility = Visibility.Visible;
                }
                else
                {
                    LikeButton.IsEnabled = true;
                    ImageInformationsButton.Visibility = Visibility.Collapsed;
                    LockButton.Visibility = Visibility.Collapsed;
                }
                ConfigImageViewButtons();
            }
        }

        private void ConfigImageViewButtons()
        {
            switch (CurrentGalleryCard.Image.protectionLevel)
            {
                case "public":
                    {
                        LockButton.IsChecked = false;
                        ImageInformationsButton.IsEnabled = true;
                        break;
                    }
                case "private":
                    {
                        LockButton.IsChecked = true;
                        ImageInformationsButton.IsEnabled = true;
                        break;
                    }
                case "protected":
                    {
                        LockButton.IsChecked = false;
                        ImageInformationsButton.IsEnabled = true;
                        break;
                    }
            }
        }

        private void LockButton_Click(object sender, RoutedEventArgs e)
        {
            if ((bool)LockButton.IsChecked)
            {
                CurrentGalleryCard.Image.protectionLevel = "private";
            }
            else if (CurrentGalleryCard.Image.password == null || CurrentGalleryCard.Image.password == "")
            {
                CurrentGalleryCard.Image.protectionLevel = "public";
            } else
            {
                CurrentGalleryCard.Image.protectionLevel = "protected";
            }
            CurrentGalleryCard.ConfigIcon();
            ImageDao.Put(CurrentGalleryCard.Image);
            ConfigImageViewButtons();

        }

        private void LikeButton_Click(object sender, RoutedEventArgs e)
        {
            ImageLike imageLike = new ImageLike
            {
                imageId = CurrentGalleryCard.Image.id,
                userId = ServerService.instance.user.id
            };
            if ((bool)LikeButton.IsChecked)
            {
                ImagePreviewRoom.AddLike();
            }
            else
            {
                ImagePreviewRoom.RemoveLike();
            }
        }

        private void EditButton_Click(object sender, RoutedEventArgs e)
        {
            CreateImageContainer.Visibility = Visibility.Collapsed;
            EditImageInformationsContainer.Visibility = Visibility.Collapsed;
            AccessImageContainer.Visibility = Visibility.Visible;
            ShareImageContainer.Visibility = Visibility.Collapsed;
            ImageToAccessPassword.Text = "";
            WrongPasswordMessage.IsActive = false;
            if (ServerService.instance.isOffline() || CurrentGalleryCard.Image.protectionLevel != "protected" || CurrentGalleryCard.Image.ownerId == ServerService.instance.user.id)
            {
                ((MainWindow)Application.Current.MainWindow).LoadImage(CurrentGalleryCard.Image.id);
            }
        }

        private void AddCommentButton_Click(object sender, RoutedEventArgs e)
        {
            ImagePreviewRoom.AddComment(CurrentComment.Text);
            CurrentComment.Text = "";
        }

        private void ImageInformationsButton_Click(object sender, RoutedEventArgs e)
        {
            CreateImageContainer.Visibility = Visibility.Collapsed;
            EditImageInformationsContainer.Visibility = Visibility.Visible;
            AccessImageContainer.Visibility = Visibility.Collapsed;
            ShareImageContainer.Visibility = Visibility.Collapsed;
            CurrentImageTitle.Text = CurrentGalleryCard.Image.title;
            CurrentImagePassword.Text = CurrentGalleryCard.Image.password;
            CurrentImagePassword.IsEnabled = (CurrentGalleryCard.Image.protectionLevel == "private") ? false : true;
        }

        private void AddImageButton_Click(object sender, RoutedEventArgs e)
        {
            CreateImageContainer.Visibility = Visibility.Visible;
            EditImageInformationsContainer.Visibility = Visibility.Collapsed;
            AccessImageContainer.Visibility = Visibility.Collapsed;
            ShareImageContainer.Visibility = Visibility.Collapsed;
            ImageTitle.Text = "";
            ImagePassword.Password = "";
            PrivateProtectionLevel.IsChecked = true;
        }

        private void ShareButton_Click(object sender, RoutedEventArgs e)
        {
            CreateImageContainer.Visibility = Visibility.Collapsed;
            EditImageInformationsContainer.Visibility = Visibility.Collapsed;
            AccessImageContainer.Visibility = Visibility.Collapsed;
            ShareImageContainer.Visibility = Visibility.Visible;

            var request = new RestRequest(Settings.API_VERSION + "/secret/generate/" + CurrentGalleryCard.Image.id, Method.GET);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    ShareLink.Text = Settings.WEB_CLIENT_LINK + "secret/" + (string)response.Content;
                });
            });
        }

        #region Dialog

        private void EditImageInformationsButton_Click(object sender, RoutedEventArgs e)
        {
            CurrentGalleryCard.ImageTitle.Text = CurrentImageTitle.Text;
            ImageViewTitle.Text = CurrentImageTitle.Text;
            if (CurrentGalleryCard.Image.protectionLevel != "private")
            {
                if (CurrentImagePassword.Text == "")
                {
                    CurrentGalleryCard.Image.password = null;
                    CurrentGalleryCard.Image.protectionLevel = "public";
                }
                else
                {
                    CurrentGalleryCard.Image.password = CurrentImagePassword.Text;
                    CurrentGalleryCard.Image.protectionLevel = "protected";
                }
                CurrentGalleryCard.ConfigIcon();
            }
            ImageDao.Put(CurrentGalleryCard.Image);
        }

        private void CreateImageClick(object sender, RoutedEventArgs e)
        {
            string protectionLevel;

            if ((bool)PrivateProtectionLevel.IsChecked)
            {
                protectionLevel = "private";
            }
            else
            {
                if (ImagePassword.Password.Length > 0)
                {
                    protectionLevel = "protected";
                }
                else
                {
                    protectionLevel = "public";
                }
            }

            Image newImage = new Image
            {
                title = ImageTitle.Text,
                ownerId = ServerService.instance.isOffline() ? null : ServerService.instance.user.id,
                id = ServerService.instance.isOffline() ? Guid.NewGuid().ToString() : null,
                password = ImagePassword.Password,
                protectionLevel = protectionLevel
            };

            ImageDao.Post(newImage);
        }



        #endregion

        private void AccessImageButton_Click(object sender, RoutedEventArgs e)
        {
            if (ImageToAccessPassword.Text != CurrentGalleryCard.Image.password)
            {
                WrongPasswordMessage.IsActive = true;
            }
            else
            {
                ((MainWindow)Application.Current.MainWindow).LoadImage(CurrentGalleryCard.Image.id);
            }
        }

        private void Search_KeyUp(object sender, System.Windows.Input.KeyEventArgs e)
        {
            List<GalleryCard> gallerycards = PublicImagesContainer.Children.Cast<GalleryCard>().ToList();
            gallerycards.AddRange(MyImagesContainer.Children.Cast<GalleryCard>().ToList());
            string filter = ((ComboBoxItem)SearchBy.SelectedValue).Content.ToString();
            if (filter.Contains("author"))
            {
                gallerycards.ForEach(card =>
                {
                    if (card.Image.authorName.Contains(Search.Text))
                    {
                        card.Visibility = Visibility.Visible;
                    }
                    else
                    {
                        card.Visibility = Visibility.Collapsed;
                    }
                    return;
                });
            }
            else
            {
                gallerycards.ForEach(card =>
                {
                    if (card.Image.title.Contains(Search.Text))
                    {
                        card.Visibility = Visibility.Visible;
                    }
                    else
                    {
                        card.Visibility = Visibility.Collapsed;
                    }
                    return;
                });
            }
        }

        private void CopyToClipboard_Click(object sender, RoutedEventArgs e)
        {
            Clipboard.SetText(ShareLink.Text);
        }
    }
}
