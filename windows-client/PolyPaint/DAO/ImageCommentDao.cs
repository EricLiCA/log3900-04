using PolyPaint.Modeles;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using PolyPaint.Vues;
using RestSharp;
using System.Net;
using System.Windows;

namespace PolyPaint.DAO
{
    public static class ImageCommentDao
    {

        public static void Get(string imageId)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGE_COMMENTS_PATH + "/" + imageId, Method.GET);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                    currentGallery.LoadCurrentImageComments(response);
                });
            });
        }

        public static void Post(ImageComment imageComment)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGE_COMMENTS_PATH, Method.POST);
            request.AddJsonBody(imageComment);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode != HttpStatusCode.Created)
                    {
                        MessageBox.Show("Could not add a comment", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }
    }
}
