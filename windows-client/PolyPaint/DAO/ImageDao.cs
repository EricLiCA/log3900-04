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

        public static void GetAll(WrapPanel imagesContainer)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGES_PATH, Method.GET);
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        imagesContainer.Children.Clear();
                        JArray responseImages = JArray.Parse(response.Content);
                        for (int i = 0; i < responseImages.Count; i++)
                        {
                            dynamic data = JObject.Parse(responseImages[i].ToString());
                            Image image = new Image
                            {
                                id = data["id"],
                                ownerId = data["ownerId"],
                                title = data["title"],
                                protectionLevel = data["protectionLevel"],
                                password = data["password"],
                                thumbnailUrl = data["thumbnailUrl"],
                                fullImageUrl = data["fullImageUrl"]
                            };
                            GalleryCard galleryCard = new GalleryCard(image);
                            imagesContainer.Children.Add(galleryCard);
                        }
                    }
                    else
                    {
                        MessageBox.Show("Could not load the images", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
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
