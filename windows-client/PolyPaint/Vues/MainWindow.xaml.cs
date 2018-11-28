using System;
using System.ComponentModel;
using System.Windows;
using System.Windows.Media.Imaging;
using PolyPaint.DAO;
using PolyPaint.Modeles;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using PolyPaint.VueModeles;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public Tutorial tutorial = new Tutorial();
        public Gallery Gallery = new Gallery();
        public Users Users;
        public FenetreDessin FenetreDessin = new FenetreDessin();
        Window detached;
        bool isDetached = true;

        public MainWindow()
        {
            InitializeComponent();
            GridMain.Content = tutorial;
            OfflineMode();

            Closing += new CancelEventHandler(((MainWindow)Application.Current.MainWindow).FenetreDessin.SaveButton_Click);
        }

        public void showDetachedChat(object sender, EventArgs e)
        {
            this.isDetached = true;
            if (GridMain.Content is MessagingWindow)
                GoToGallery();
            RefreshView();
            ButtonChat.IsEnabled = false;
            detached = new DetachedChat();
            detached.Show();
        }

        public void showAttachedChat(object sender, EventArgs e)
        {
            detached.Hide();
            ButtonChat.IsEnabled = true;
            this.isDetached = false;
            RefreshView();
        }

        public void OfflineMode()
        {
            if (detached != null)
                detached.Hide();

            ManageProfileButton.Visibility = Visibility.Collapsed;
            AvatarButton.Visibility = Visibility.Collapsed;
            ConnectButton.Visibility = Visibility.Visible;
            DisonnectButton.Visibility = Visibility.Collapsed;

            ButtonUsers.IsEnabled = false;
            ButtonChat.IsEnabled = false;
            ButtonEdit.IsEnabled = false;

            Gallery = new Gallery();
            GridMain.Content = tutorial;
            GridCursor.Margin = new Thickness(10, 0, 0, 0);
        }

        public void OnlineMode()
        {
            ManageProfileButton.Visibility = Visibility.Visible;
            AvatarButton.Visibility = Visibility.Visible;
            DisonnectButton.Visibility = Visibility.Visible;
            ConnectButton.Visibility = Visibility.Collapsed;

            Uri profileImage = ServerService.instance.user.profileImage;
            if (profileImage != null)
            {
                AvatarImage.Source = new BitmapImage(profileImage);
            }

            Users = new Users();
            Gallery = new Gallery();

            ButtonUsers.IsEnabled = true;
            if (isDetached)
                showDetachedChat(null, null);
            else
                showAttachedChat(null, null);

            UsersManager.instance.fetchAll();
        }

        private void RefreshView()
        {
            if (GridMain.Content is Gallery)
            {
                Button_Click(ButtonGallery, null);
            }
            else if (GridMain.Content is FenetreDessin)
            {
                Button_Click(ButtonEdit, null);
            }
            else if (GridMain.Content is Users)
            {
                Button_Click(ButtonUsers, null);
            }
            else if (GridMain.Content is MessagingWindow)
            {
                Button_Click(ButtonChat, null);
            }
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            int index = int.Parse(((System.Windows.Controls.Button)sender).Uid);

            switch (index)
            {
                case 0:
                    {
                        GridMain.Content = this.tutorial;
                        GridCursor.Margin = new Thickness(10, 0, 0, 0);
                        break;
                    }
                case 1:
                    {
                        Gallery.Load();
                        GoToGallery();
                        break;
                    }
                case 2:
                    Users.Load();
                    GridMain.Content = Users;
                    GridCursor.Margin = new Thickness(10 + 150 * 2, 0, 0, 0);
                    break;
                case 3:
                    if (isDetached) break;
                    GridMain.Content = MessagingViewManager.instance.LargeMessagingView;
                    GridCursor.Margin = new Thickness(10 + 150 *3, 0, 0, 0);
                    break;
                case 4:
                    GoToEditMode(4);
                    break;
            }
        }

        public void GoToGallery()
        {
            GridMain.Content = Gallery;
            GridCursor.Margin = new Thickness(10 + 150, 0, 0, 0);
        }

        public void GoToEditMode(int index)
        {
            GridMain.Content = this.FenetreDessin;
            GridCursor.Margin = new Thickness(10 + 150*4, 0, 0, 0);
        }

        private void Menu_Change_Avatar_Click(object sender, System.EventArgs e)
        {
            string fileName = null;

            using (System.Windows.Forms.OpenFileDialog openFileDialog1 = new System.Windows.Forms.OpenFileDialog())
            {
                openFileDialog1.InitialDirectory = "c:\\";
                openFileDialog1.Filter = "Image files (*.jpg, *.jpeg, *.jpe, *.jfif, *.png) | *.jpg; *.jpeg; *.jpe; *.jfif; *.png";
                openFileDialog1.FilterIndex = 2;
                openFileDialog1.RestoreDirectory = true;

                if (openFileDialog1.ShowDialog().ToString().Equals("OK"))
                {
                    fileName = openFileDialog1.FileName;
                }
            }

            if (fileName != null)
            {
                try 
                {
                    String avatarLocation = fileName;
                    BitmapImage bitmap = new BitmapImage();
                    bitmap.BeginInit();
                    bitmap.UriSource = new Uri(avatarLocation);
                    bitmap.DecodePixelHeight = 40;
                    bitmap.DecodePixelWidth = 40;
                    bitmap.EndInit();
                    AvatarImage.Source = bitmap;

                    ServerService.instance.S3Communication.UploadProfileImageAsync(avatarLocation);

                    Uri avatarImageToUploadToSQL = new Uri(Settings.URL_TO_PROFILE_IMAGES + ServerService.instance.user.id);
                    ServerService.instance.user.profileImage = avatarImageToUploadToSQL;
                    UserDao.Put(ServerService.instance.user);
                }
                catch(Exception exception)
                {
                    MessageBox.Show("The image is not valid", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                }

            }
        }

        private void ManageProfileButton_Click(object sender, RoutedEventArgs e)
        {
            CurrentProfileName.Text = ServerService.instance.user.username;
            CurrentProfilePassword.Password = ServerService.instance.user.password;
        }

        private void ChangeProfileInformationsButton_Click(object sender, System.EventArgs e)
        {
            User userToUpdate = new User()
            {
                id = ServerService.instance.user.id,
                token = ServerService.instance.user.token,
                password = ServerService.instance.user.password,
                profileImage = ServerService.instance.user.profileImage,
                userLevel = ServerService.instance.user.userLevel,
                username = ServerService.instance.user.username
            };
            userToUpdate.username = CurrentProfileName.Text;
            userToUpdate.password = CurrentProfilePassword.Password;
            UserDao.Put(userToUpdate);
            ChangeProfileInformationsButton.IsEnabled = false;
        }

        private void CloseDialogButton_Click(object sender, RoutedEventArgs e)
        {
            ChangeProfileInformationsButton.IsEnabled = false;
        }

        private void CurrentProfileInformations_KeyUp(object sender, System.Windows.Input.KeyEventArgs e)
        {
            Boolean invalideUserName = CurrentProfileName.Text.Length == 0 || CurrentProfileName.Text.Contains(" ");
            Boolean invalidPassword = CurrentProfilePassword.Password.Length == 0 || CurrentProfilePassword.Password.Contains(" ");

            if (invalideUserName || invalidPassword)
            {
                ChangeProfileInformationsButton.IsEnabled = false;
            }
            else
            {
                ChangeProfileInformationsButton.IsEnabled = true;
            }
        }

        public void LoadImage(string imageId)
        {
            GoToEditMode(3);
            FenetreDessin.SaveButton_Click(null, null);
            ServerService.instance.currentImageId = imageId;
            ButtonEdit.IsEnabled = true;
            Button_Click(ButtonEdit, null);
            ((VueModele)FenetreDessin.DataContext).editeur.SyncToServer();
        }

        private void ConnectButton_Click(object sender, RoutedEventArgs e)
        {
            LoginDialogBox dlg = new LoginDialogBox();
            if (dlg.ShowDialog() == true)
            {
                OnlineMode();
            }
        }

        private void DisonnectButton_Click(object sender, RoutedEventArgs e)
        {
            ServerService.instance.disconnect();
            OfflineMode();
        }
    } 
}
