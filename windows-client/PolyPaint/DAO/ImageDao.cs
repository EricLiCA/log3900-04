using RestSharp;
using PolyPaint.Utilitaires;
using PolyPaint.Services;
using System.Net;
using System.Windows;
using Image = PolyPaint.Modeles.Image;
using PolyPaint.Vues;

namespace PolyPaint.DAO
{
    public static class ImageDao
    {
        public static void GetByOwnerId()
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGES_BY_OWNER_ID_PATH + "/" + ServerService.instance.user.id, Method.GET);
            ServerService.instance.server.ExecuteAsync<Image>(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                    currentGallery.LoadMyImages(response);
                });
            });
        }

        public static void GetPublicExceptMine()
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGES_PUBLIC_EXCEPT_MINE + "/" + ServerService.instance.user.id, Method.GET);
            ServerService.instance.server.ExecuteAsync<Image>(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                    currentGallery.LoadPublicImages(response);
                });
            });
        }

        public static void Put(Image imageToUpdate)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGES_PATH + "/" + imageToUpdate.id, Method.PUT);
            request.AddJsonBody(imageToUpdate);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                if (response.StatusCode != HttpStatusCode.OK)
                {
                    MessageBox.Show("Could not update the image", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            });
        }

    }

}
