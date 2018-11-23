using System;
using System.Windows;
using System.Windows.Forms;
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
        public Gallery Gallery;
        public Users Users;
        public FenetreDessin FenetreDessin;
        Window detached;
        bool isDetached = true;

        public MainWindow()
        {
            Server_Connect();
            UsersManager.instance.fetchAll();
            FenetreDessin = new FenetreDessin();
            InitializeComponent();
            Gallery = new Gallery();
            Users = new Users();
            GridMain.Content = Gallery;
            InitDialogBox();
            if (ServerService.instance.user.isGuest)
            {
                RestrictPermissions();
            }
            else
            {
                Uri profileImage = ServerService.instance.user.profileImage;
                if(profileImage != null)
                {
                    AvatarImage.Source = new BitmapImage(profileImage);
                }
            }

            showDetachedChat(null, null);
        }

        public void showDetachedChat(object sender, EventArgs e)
        {
            this.isDetached = true;
            if (GridMain.Content == MessagingViewManager.instance.LargeMessagingView)
            {
                Button_Click(ButtonGallery, null);
            }
            else if (GridMain.Content == FenetreDessin)
            {
                Button_Click(ButtonEdit, null);
            }
            ButtonChat.Visibility = Visibility.Collapsed;
            detached = new DetachedChat();
            detached.Show();
        }

        public void showAttachedChat(object sender, EventArgs e)
        {
            detached.Hide();
            ButtonChat.Visibility = Visibility.Visible;
            this.isDetached = false;
            if (GridMain.Content == FenetreDessin)
            {
                Button_Click(ButtonEdit, null);
            }
        }

        private void RestrictPermissions()
        {
            ManageProfileButton.Visibility = Visibility.Collapsed;
            AvatarButton.IsEnabled = false;
        }

        private void Server_Connect()
        {
            LoginDialogBox dlg = new LoginDialogBox();
            if (dlg.ShowDialog() == false)
            {
                System.Environment.Exit(0);
            }
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            int index = int.Parse(((System.Windows.Controls.Button)sender).Uid);

            switch (index)
            {
                case 0:
                    {
                        Gallery.Load();
                        GoToGallery(0);
                        break;
                    }
                case 1:
                    {
                        Users.Load();
                        GridMain.Content = Users;
                        GridCursor.Margin = new Thickness(10 + (150 * index), 0, 0, 0);
                        break;
                    }
                case 2:
                    if (isDetached) break;
                    GridMain.Content = MessagingViewManager.instance.LargeMessagingView;
                    GridCursor.Margin = new Thickness(10 + (150 * index), 0, 0, 0);
                    break;
                case 3:
                    GoToEditMode(3);
                    break;
            }
        }

        public void GoToGallery(int index)
        {
            GridMain.Content = Gallery;
            GridCursor.Margin = new Thickness(10 + (150 * index), 0, 0, 0);
        }

        public void GoToEditMode(int index)
        {
            GridMain.Content = this.FenetreDessin;
            GridCursor.Margin = new Thickness(10 + (150 * (index - (isDetached ? 1 : 0))), 0, 0, 0);
        }

        private void Menu_Change_Avatar_Click(object sender, System.EventArgs e)
        {
            string fileName = null;

            using (OpenFileDialog openFileDialog1 = new OpenFileDialog())
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
                String avatarLocation = fileName;
                BitmapImage bitmap = new BitmapImage();
                bitmap.BeginInit();
                bitmap.UriSource = new Uri(avatarLocation);
                bitmap.DecodePixelHeight = 40;
                bitmap.DecodePixelWidth = 40;
                bitmap.EndInit();
                AvatarImage.Source = bitmap;

                ServerService.instance.S3Communication.UploadFileAsync(avatarLocation);

                Uri avatarImageToUploadToSQL = new Uri(Settings.URL_TO_PROFILE_IMAGES + ServerService.instance.user.id);
                ServerService.instance.user.profileImage = avatarImageToUploadToSQL;
                UserDao.Put(ServerService.instance.user);
            }
        }

        private void InitDialogBox()
        {
            CurrentProfileName.Text = ServerService.instance.user.username;
            CurrentProfilePassword.Password = ServerService.instance.user.password;
        }

        private void ChangeProfileInformationsButton_Click(object sender, System.EventArgs e)
        {
            ServerService.instance.user.username = CurrentProfileName.Text;
            ServerService.instance.user.password = CurrentProfilePassword.Password;
            UserDao.Put(ServerService.instance.user);
            ChangeProfileInformationsButton.IsEnabled = false;
        }

        private void CloseDialogButton_Click(object sender, RoutedEventArgs e)
        {
            InitDialogBox();
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
            ServerService.instance.currentImageId = imageId;
            ButtonEdit.Visibility = Visibility.Visible;
            GridMain.Content = FenetreDessin;
            ((VueModele)FenetreDessin.DataContext).editeur.SyncToServer();
        }
    }
}
