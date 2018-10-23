using RestSharp;
using PolyPaint.Utilitaires;
using PolyPaint.Services;
using System.Net;
using System.Windows;
using Newtonsoft.Json.Linq;
using Image = PolyPaint.Modeles.Image;
using PolyPaint.Vues;
using System.Windows.Controls;
using RestSharp.Deserializers;

namespace PolyPaint.DAO
{
    public static class ImageDao
    {

        public static void GetAll()
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGES_PATH, Method.GET);
            ServerService.instance.server.ExecuteAsync<Image>(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                    currentGallery.LoadImages(response);
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
