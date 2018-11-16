using Newtonsoft.Json.Linq;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using PolyPaint.Vues;
using RestSharp;
using System.Net;
using System.Windows;
using Image = PolyPaint.Modeles.Image;

namespace PolyPaint.DAO
{
    public static class ImageDao
    {
        public static void GetByOwnerId()
        {
            if (ServerService.instance.isOffline()) {
                Application.Current.Dispatcher.InvokeAsync(() =>
                {
                    var response = OfflineFileLoader.getAll();
                    MainWindow sd = ((MainWindow)Application.Current.MainWindow);
                    Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                    currentGallery.LoadMyImages(response);
                });
                return;
            }

            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGES_BY_OWNER_ID_PATH + "/" + ServerService.instance.user.id, Method.GET);
            ServerService.instance.server.ExecuteAsync<Image>(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        Gallery currentGallery = ((MainWindow)Application.Current.MainWindow).Gallery;
                        currentGallery.LoadMyImages(response.Content);
                    }
                    else
                    {
                        MessageBox.Show("Could not load the images", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }

        public static void GetPublicExceptMine()
        {
            if (ServerService.instance.isOffline())
                return;

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
            if (ServerService.instance.isOffline())
            {
                OfflineFileLoader.put(imageToUpdate);
                return;
            }

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

        public static void Post(Image newImage)
        {
            if (ServerService.instance.isOffline())
            {
                OfflineFileLoader.post(newImage);
                ((MainWindow)Application.Current.MainWindow).LoadImage(newImage.id);
                return;
            }

            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGES_PATH, Method.POST);
            request.AddJsonBody(newImage);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode == HttpStatusCode.Created)
                    {
                        dynamic data = JObject.Parse(response.Content);
                        ((MainWindow)Application.Current.MainWindow).LoadImage((string)data["id"]);
                    }
                    else
                    {
                        MessageBox.Show("Could not create the image", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }

    }

}
