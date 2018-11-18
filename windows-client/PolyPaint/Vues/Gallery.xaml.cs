using Newtonsoft.Json.Linq;
using PolyPaint.DAO;
using PolyPaint.Modeles;
using PolyPaint.Services;
using RestSharp;
using System;
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
            if (ServerService.instance.user.isGuest)
            {
                RestrictPermissions();
            }
            else
            {
                ImageDao.GetByOwnerId();
            }
            ImageDao.GetPublicExceptMine();
        }

        private void RestrictPermissions()
        {
            MyImagesGroupBox.Visibility = Visibility.Collapsed;
            LikeButton.IsEnabled = false;
            LockButton.IsEnabled = false;
            PasswordButton.IsEnabled = false;
            CurrentComment.IsEnabled = false;
            AddCommentButton.IsEnabled = false;
        }

        public void LoadMyImages(IRestResponse response)
        {
            if (response.StatusCode == HttpStatusCode.OK)
            {
                MyImagesContainer.Children.Clear();
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
                    MyImagesContainer.Children.Add(galleryCard);
                }
            }
            else
            {
                MessageBox.Show("Could not load the images", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
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
                        thumbnailUrl = data["thumbnailUrl"],
                        fullImageUrl = data["fullImageUrl"],
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
            for (int i =0; i < ImagePreviewRoom.Likes.Count; i++)
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
            CurrentImagePassword.Text = CurrentGalleryCard.Image.password;
            Uri imageUri = new Uri(CurrentGalleryCard.Image.fullImageUrl);
            BitmapImage imageBitmap = new BitmapImage(imageUri);
            ImageViewPicture.Source = imageBitmap;

            ImagePreviewRoom.ImageId = CurrentGalleryCard.Image.id;
            ImagePreviewRoom.PreviewImage();

            if (!ServerService.instance.user.isGuest)
            {
                if (CurrentGalleryCard.Image.ownerId == ServerService.instance.user.id)
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
        }

        private void LockButton_Click(object sender, RoutedEventArgs e)
        {
            if ((bool)LockButton.IsChecked)
            {
                CurrentGalleryCard.Image.protectionLevel = "private";
            }
            else
            {
                CurrentGalleryCard.Image.protectionLevel = "public";
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
            ChangePasswordContainer.Visibility = Visibility.Collapsed;
            AccessImageContainer.Visibility = Visibility.Visible;
            ImageToAccessPassword.Text = "";
            WrongPasswordMessage.IsActive = false;
            if (CurrentGalleryCard.Image.protectionLevel != "protected" || CurrentGalleryCard.Image.ownerId == ServerService.instance.user.id)
            {
                ((MainWindow)Application.Current.MainWindow).LoadImage(CurrentGalleryCard.Image.id);
            }
        }

        private void AddCommentButton_Click(object sender, RoutedEventArgs e)
        {
            ImagePreviewRoom.AddComment(CurrentComment.Text);
            CurrentComment.Text = "";
        }

        private void PasswordButton_Click(object sender, RoutedEventArgs e)
        {
            CreateImageContainer.Visibility = Visibility.Collapsed;
            ChangePasswordContainer.Visibility = Visibility.Visible;
            AccessImageContainer.Visibility = Visibility.Collapsed;
            CurrentImagePassword.Text = CurrentGalleryCard.Image.password;
        }

        private void AddImageButton_Click(object sender, RoutedEventArgs e)
        {
            CreateImageContainer.Visibility = Visibility.Visible;
            ChangePasswordContainer.Visibility = Visibility.Collapsed;
            AccessImageContainer.Visibility = Visibility.Collapsed;
            ImageTitle.Text = "";
            ImagePassword.Password = "";
            PrivateProtectionLevel.IsChecked = true;
        }

        #region Dialog

        private void AddPasswordButton_Click(object sender, RoutedEventArgs e)
        {
            CurrentGalleryCard.Image.password = CurrentImagePassword.Text;
            CurrentGalleryCard.Image.protectionLevel = "protected";
            CurrentGalleryCard.ConfigIcon();
            ImageDao.Put(CurrentGalleryCard.Image);
        }

        private void RemovePasswordButton_Click(object sender, RoutedEventArgs e)
        {
            CurrentGalleryCard.Image.password = null;
            CurrentGalleryCard.Image.protectionLevel = "public";
            CurrentGalleryCard.ConfigIcon();
            CurrentImagePassword.Text = null;
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
                ownerId = ServerService.instance.user.id,
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
    }
}
