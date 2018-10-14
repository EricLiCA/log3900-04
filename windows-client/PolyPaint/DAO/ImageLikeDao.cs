using PolyPaint.Modeles;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using PolyPaint.Vues;
using RestSharp;
using System.Net;
using System.Windows;

namespace PolyPaint.DAO
{
    public static class ImageLikeDao
    {

        public static void Get(string imageId)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGE_LIKES_PATH + "/" + imageId, Method.GET);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                    currentGallery.LoadCurrentImageLikes(response);
                });
            });
        }

        public static void Post(ImageLike imageLike)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGE_LIKES_PATH, Method.POST);
            request.AddJsonBody(imageLike);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode != HttpStatusCode.Created)
                    {
                        MessageBox.Show("Could not add a like", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }

        public static void Delete(ImageLike imageLike)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGE_LIKES_PATH + "/" + imageLike.imageId + "/" + imageLike.userId, Method.DELETE);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode != HttpStatusCode.OK)
                    {
                        MessageBox.Show("Could not delete the like", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }
    }
}
