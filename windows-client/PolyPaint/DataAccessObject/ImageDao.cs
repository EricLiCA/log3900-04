using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RestSharp;
using PolyPaint.Utilitaires;
using PolyPaint.Services;
using System.Net;
using PolyPaint.Modeles;
using System.Windows;
using Newtonsoft.Json.Linq;
using System.Windows.Controls;

namespace PolyPaint.DataAccessObject
{
    class ImageDao
    {

        public void GetAll(TextBox user)
        {
            var request = new RestRequest(Settings.API_VERSION + Settings.IMAGES_PATH, Method.GET);
            var a = ServerService.instance.server.ExecuteAsync(request, response =>
            {
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    var obj = JArray.Parse(response.Content);
                    dynamic data = JObject.Parse(obj[0].ToString());
                    string id = data["id"];
                    user.Text = id;
                }
                else
                {
                    MessageBox.Show("Could not load the images", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            });            
        }
    }
}
