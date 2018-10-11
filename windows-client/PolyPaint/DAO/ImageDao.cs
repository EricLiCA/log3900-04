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
    public class ImageDao
    {

        public void GetAll(WrapPanel imagesContainer)
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
                                Id = data["id"],
                                OwnerId = data["ownerId"],
                                Title = data["title"],
                                ProtectionLevel = data["protectionLevel"],
                                Password = data["password"],
                                ThumbnailUrl = data["thumbnailUrl"],
                                FullImageUrl = data["fullImageUrl"]
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

        public void Update(Image imageToUpdate)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGES_PATH + "/" + imageToUpdate.Id, Method.PUT);
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
