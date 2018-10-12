using RestSharp;
using PolyPaint.Utilitaires;
using PolyPaint.Services;
using System.Net;
using System.Windows;
using Newtonsoft.Json.Linq;
using Image = PolyPaint.Modeles.Image;
using PolyPaint.Vues;
using System.Windows.Controls;

namespace PolyPaint.DAO
{
    public static class ImageDao
    {

        public static void GetAll()
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGES_PATH, Method.GET);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                    currentGallery.FillWithImages(response);
                });
            });
        }

        public static void Update(Image imageToUpdate)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGES_PATH + "/" + imageToUpdate.id, Method.PUT);
            request.AddJsonBody(imageToUpdate);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {

                    }
                    else
                    {
                        MessageBox.Show("Could not update the image", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }
    }


}
