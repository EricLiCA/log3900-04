using Newtonsoft.Json.Linq;
using PolyPaint.Services;
using PolyPaint.Vues;
using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;

namespace PolyPaint.Modeles
{
    public class ImagePreviewRoom
    {
        public string ImageId { get; set; }
        public ObservableCollection<ImageLike> Likes { get; set; }
        public WrapPanel Comments { get; set; }

        public ImagePreviewRoom(WrapPanel commentsContainer)
        {
            this.Likes = new ObservableCollection<ImageLike>();
            this.Comments = commentsContainer;
        }

        public void startListening()
        {
            this.OnPreviewImage();
            this.OnAddComment();
            this.OnAddLike();
            this.OnRemoveLike();
        }

        public void PreviewImage()
        {
            if (!ServerService.instance.isOffline())
            {
                this.startListening();
                ServerService.instance.Socket.Emit("previewImage", this.ImageId);
            }
            else
            {
                this.ImageId = ServerService.instance.currentImageId;
                this.Likes.Clear();
                this.Comments.Children.Clear();
                Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                currentGallery.CheckOrUncheckLikeButton();
            }
        }

        public void LeaveImage()
        {
            ServerService.instance.Socket.Emit("leaveImage");
        }

        public void AddComment(string comment)
        {
            ServerService.instance.Socket.Emit("addComment", ServerService.instance.user.id, comment, ServerService.instance.user.username, ServerService.instance.user.profileImage);
        }

        public void AddLike()
        {
            ServerService.instance.Socket.Emit("addLike", ServerService.instance.user.id);
        }

        public void RemoveLike()
        {
            ServerService.instance.Socket.Emit("removeLike", ServerService.instance.user.id);
        }

        private void OnPreviewImage()
        {
            ServerService.instance.Socket.Off("previewImage");
            ServerService.instance.Socket.On("previewImage", new CustomListener((dynamic[] server_params) =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    dynamic data = JObject.Parse(server_params[0].ToString());
                    this.ImageId = data["id"];
                    this.Likes.Clear();
                    this.Comments.Children.Clear();
                    for (int i = 0; i < data["likes"]?.Count; i++)
                    {
                        this.Likes.Add(new ImageLike() { imageId = data["likes"][i]["ImageId"], userId = data["likes"][i]["UserId"] });
                    }
                    for (int i = 0; i < data["comments"]?.Count; i++)
                    {
                        ImageComment comment = new ImageComment()
                        {
                            imageId = data["comments"][i]["ImageId"],
                            userId = data["comments"][i]["UserId"],
                            comment = data["comments"][i]["Comment"],
                            timestamp = data["comments"][i]["Timestamp"],
                            userName = data["comments"][i]["UserName"],
                            profileImage = data["comments"][i]["ProfileImage"]
                        };
                        this.Comments.Children.Add(new GalleryComment(comment));
                    }
                    Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                    currentGallery.CheckOrUncheckLikeButton();
                });
            }));
        }

        private void OnAddComment()
        {
            ServerService.instance.Socket.Off("addComment");
            ServerService.instance.Socket.On("addComment", new CustomListener((object[] server_params) =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    dynamic data = JObject.Parse(server_params[0].ToString());
                    ImageComment newComment = new ImageComment()
                    {
                        imageId = data["ImageId"],
                        userId = data["UserId"],
                        comment = data["Comment"],
                        timestamp = data["Timestamp"],
                        userName = data["UserName"],
                        profileImage = data["ProfileImage"]
                    };
                    this.Comments.Children.Add(new GalleryComment(newComment));
                    Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                    currentGallery.CheckOrUncheckLikeButton();
                });
            }));
        }

        private void OnAddLike()
        {
            ServerService.instance.Socket.Off("addLike");
            ServerService.instance.Socket.On("addLike", new CustomListener((object[] server_params) =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    dynamic data = JObject.Parse(server_params[0].ToString());
                    this.Likes.Add(new ImageLike() { imageId = data["ImageId"], userId = data["UserId"] });
                    Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                    currentGallery.CheckOrUncheckLikeButton();
                });
            }));
        }

        private void OnRemoveLike()
        {
            ServerService.instance.Socket.Off("removeLike");
            ServerService.instance.Socket.On("removeLike", new CustomListener((object[] server_params) =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    dynamic data = JObject.Parse(server_params[0].ToString());
                    ImageLike removedLike = new ImageLike() { imageId = data["ImageId"], userId = data["UserId"] };
                    for (int i = 0; i < this.Likes.Count; i++)
                    {
                        if (this.Likes[i].imageId == removedLike.imageId && this.Likes[i].userId == removedLike.userId)
                        {
                            this.Likes.Remove(this.Likes[i]);
                        }
                    }
                    Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                    currentGallery.CheckOrUncheckLikeButton();
                });
            }));
        }
    }
}
