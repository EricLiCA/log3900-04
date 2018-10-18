using Newtonsoft.Json.Linq;
using PolyPaint.Modeles;
using RestSharp;
using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Imaging;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for Users.xaml
    /// </summary>
    public partial class Users : Page
    {
        public UsersCard CurrentUserCard { get; set; }

        public Users()
        {
            InitializeComponent();
        }

        public void LoadUsers(IRestResponse response)
        {
            if (response.StatusCode == HttpStatusCode.OK)
            {
                FriendsContainer.Children.Clear();
                ConnectedUsersContainer.Children.Clear();
                JArray responseUsers= JArray.Parse(response.Content);
                for (int i = 0; i < responseUsers.Count; i++)
                {
                    dynamic data = JObject.Parse(responseUsers[i].ToString());
                    User user = new User
                    {
                        id = data["id"],
                        username = data["username"],
                        profileImage = data["profileImage"],
                    };
                    UsersCard userCard = new UsersCard(user);
                    userCard.ViewButtonClicked += ViewButton_Click;
                    ConnectedUsersContainer.Children.Add(userCard);
                }
            }
            else
            {
                MessageBox.Show("Could not load the profile", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ViewButton_Click(object sender, EventArgs e)
        {
            UsersCard userCard = (UsersCard)sender;
            CurrentUserCard = userCard;
            ProfileView.Visibility = Visibility.Visible;
            ProfileView.IsExpanded = true;
            ProfileViewTitle.Text = CurrentUserCard.User.username;
            Uri imageUri = new Uri(CurrentUserCard.User.profileImage);
            BitmapImage imageBitmap = new BitmapImage(imageUri);
            ProfileViewPicture.Source = imageBitmap;
        }

        private void FriendButton_Checked(object sender, RoutedEventArgs e)
        {
            // TODO: Sent a friend request to the currentProfile

        }

        private void FriendButton_Unchecked(object sender, RoutedEventArgs e)
        {
            // TODO: Delete a friend from the friend list
        }

        private void AddToChannelButton_Click(object sender, RoutedEventArgs e)
        {
            // TODO: Add to channel
        }

        private void ViewImagesButton_Click(object sender, RoutedEventArgs e)
        {
            // TODO: Go to gallery and filter image in order to show currentProfile images
        }
    }
}
