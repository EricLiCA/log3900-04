using Newtonsoft.Json.Linq;
using PolyPaint.DAO;
using PolyPaint.Modeles;
using PolyPaint.Services;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
        ObservableCollection<PendingFriendRequest> PendingFriendRequestsList;
        List<string> SentRequests;


        public Users()
        {
            InitializeComponent();
            PendingFriendRequestsList = new ObservableCollection<PendingFriendRequest>();
            SentRequests = new List<string>();
            FriendDao.Get();
            FriendDao.GetUsersExceptFriends();
            PendingFriendRequestDao.Get();
            PendingFriendRequestDao.GetByRequesterId();
        }

        public void LoadUsersExceptFriends(IRestResponse response)
        {
            if (response.StatusCode == HttpStatusCode.OK)
            {
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
        }

        public void LoadFriends(IRestResponse response)
        {
            if (response.StatusCode == HttpStatusCode.OK)
            {
                FriendsContainer.Children.Clear();
                JArray responseUsers = JArray.Parse(response.Content);
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
                    FriendsContainer.Children.Add(userCard);
                }
            }
        }

        public void LoadPendingFriendRequests(IRestResponse response)
        {
            if (response.StatusCode == HttpStatusCode.OK)
            {
                PendingFriendRequestsList.Clear();
                JArray responseRequests = JArray.Parse(response.Content);
                for (int i = 0; i < responseRequests.Count; i++)
                {
                    dynamic data = JObject.Parse(responseRequests[i].ToString());
                    PendingFriendRequest friendRequest = new PendingFriendRequest
                    {
                        notified = data["notified"],
                        id = data["id"],
                        userName = data["userName"],
                        profileImage = data["profileImage"],
                    };
                    PendingFriendRequestsList.Add(friendRequest);
                }
                PendingFriendRequestsContainer.ItemsSource = PendingFriendRequestsList;
            }
        }

        public void LoadSentRequests(IRestResponse response)
        {
            if (response.StatusCode == HttpStatusCode.OK)
            {
                SentRequests.Clear();
                JArray responseRequests = JArray.Parse(response.Content);
                for (int i = 0; i < responseRequests.Count; i++)
                {
                    dynamic data = JObject.Parse(responseRequests[i].ToString());
                    SentRequests.Add((string)data["receiverId"]);
                }
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
            if (SentRequests.Contains(userCard.User.id))
            {
                FriendButton.IsEnabled = false;
            }
            else if (FriendsContainer.Children.Contains(userCard))
            {
                FriendButton.IsChecked = true;
                FriendButton.IsEnabled = true;
            }
            else
            {
                FriendButton.IsChecked = false;
                FriendButton.IsEnabled = true;
            }
        }

        private void AcceptFriendButton_Click(object sender, EventArgs e)
        {
            PendingFriendRequest friendRequest = (PendingFriendRequest)((Button)sender).DataContext;
            PendingFriendRequestDao.Accept(friendRequest.id);
            PendingFriendRequestsList.Remove(friendRequest);
            FriendDao.Get();
            FriendDao.GetUsersExceptFriends();
        }

        private void RefuseFriendButton_Click(object sender, EventArgs e)
        {
            PendingFriendRequest friendRequest = (PendingFriendRequest)((Button)sender).DataContext;
            PendingFriendRequestDao.Refuse(friendRequest.id);
            PendingFriendRequestsList.Remove(friendRequest);
        }

        private void FriendButton_Click(object sender, RoutedEventArgs e)
        {
            if ((bool)FriendButton.IsChecked)
            {
                PendingFriendRequestDao.Send(CurrentUserCard.User.id);
                FriendButton.IsEnabled = false;
            }
            else
            {
                FriendDao.Delete(CurrentUserCard.User.id);
                FriendsContainer.Children.Remove(CurrentUserCard);
                ConnectedUsersContainer.Children.Add(CurrentUserCard);
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
