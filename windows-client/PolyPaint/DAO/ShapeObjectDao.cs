using PolyPaint.Modeles;
using PolyPaint.Modeles.Strokes;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using RestSharp;
using System.Net;
using System.Windows;

namespace PolyPaint.DAO
{
    public static class ShapeObjectDao
    {
        public static void Post(CustomStroke customStroke)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.SHAPE_OBJECT_PATH, Method.POST);
            if (customStroke is ShapeStroke)
            {
                request.AddJsonBody(((ShapeStroke)customStroke).toJson());

            }
            else if (customStroke is BaseLine)
            {
                request.AddJsonBody(((BaseLine)customStroke).toJson());
            }
            ServerService.instance.server.ExecuteAsync(request, response =>
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    if (response.StatusCode != HttpStatusCode.Created)
                    {
                        MessageBox.Show("Could not save the image", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });
            });
        }
    }
}
