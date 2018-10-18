using Newtonsoft.Json.Linq;
using PolyPaint.DAO;
using PolyPaint.Modeles;
using PolyPaint.Services;
using RestSharp;
using System;
using System.Collections.Generic;
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
            UserDao.GetAll();
            PendingFriendRequestDao.GetAll();
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
                // TODO: get friends and fill containers
            }
            else
            {
                MessageBox.Show("Could not load the profile", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public void LoadPendingFriendRequests(IRestResponse response)
        {
            if (response.StatusCode == HttpStatusCode.OK)
            {
                List<PendingFriendRequest> friendRequestList = new List<PendingFriendRequest>();
                JArray responseRequests = JArray.Parse(response.Content);
                for (int i = 0; i < responseRequests.Count; i++)
                {
                    dynamic data = JObject.Parse(responseRequests[i].ToString());
                    PendingFriendRequest friendRequest = new PendingFriendRequest
                    {
                        notified = data["notified"],
                        receiverId = data["receiverId"],
                        requesterId = data["requesterId"],
                    };
                    friendRequestList.Add(friendRequest);
                }
                FriendList.ItemsSource = friendRequestList;
            }
            else
            {
                MessageBox.Show("Could not load the pending friend requests", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
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

        private void AcceptFriendButton_Click(object sender, EventArgs e)
        {
            User user = (User)((Button)sender).DataContext;
            PendingFriendRequest friendRequest = new PendingFriendRequest
            {
                receiverId = user.id,
                requesterId = ServerService.instance.user.id
            };
            PendingFriendRequestDao.Accept(friendRequest);
        }

        private void RefuseFriendButton_Click(object sender, EventArgs e)
        {
            User user = (User)((Button)sender).DataContext;
            PendingFriendRequest friendRequest = new PendingFriendRequest
            {
                receiverId = user.id,
                requesterId = ServerService.instance.user.id
            };
            PendingFriendRequestDao.Refuse(friendRequest);
        }

        private void FriendButton_Click(object sender, RoutedEventArgs e)
        {
            if ((bool)FriendButton.IsChecked)
            {
                PendingFriendRequestDao.Send(CurrentUserCard.User.id);
            } else
            {
                Friend friend = new Friend
                {
                    friendId = CurrentUserCard.User.id,
                    userId = ServerService.instance.user.id
                };
                FriendDao.Delete(friend);
            }

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
