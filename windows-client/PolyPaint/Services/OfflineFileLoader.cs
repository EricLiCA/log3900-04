using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using PolyPaint.Modeles;
using PolyPaint.Modeles.Strokes;
using RestSharp;

namespace PolyPaint.Services
{
    class OfflineFileLoader
    {
        public static void put(Image imageToUpdate)
        {
            string pathString = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\polypaint\\offlinefiles";
            System.IO.Directory.CreateDirectory(pathString);

            string fileContent = System.IO.File.ReadAllText(System.IO.Path.Combine(pathString, imageToUpdate.id));
            OfflineFileImage image = JObject.Parse(fileContent).ToObject<OfflineFileImage>();
            image.fullImageUrl = imageToUpdate.fullImageUrl;
            image.title = imageToUpdate.title;
            image.protectionLevel = imageToUpdate.protectionLevel;
            image.password = imageToUpdate.password;
            image.thumbnailUrl = imageToUpdate.thumbnailUrl;

            System.IO.File.WriteAllText(pathString + "\\" + image.id, JsonConvert.SerializeObject(image));
        }

        public static void post(Image newImage)
        {
            OfflineFileImage toSave = new OfflineFileImage()
            {
                id = newImage.id,
                title = newImage.title,
                protectionLevel = newImage.protectionLevel,
                password = newImage.password,
                thumbnailUrl = "https://picsum.photos/300/400/?random",
                fullImageUrl = "https://picsum.photos/300/400/?random",
                shapes = new List<SerializedStroke>()
            };

            string pathString = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\polypaint\\offlinefiles";
            System.IO.Directory.CreateDirectory(pathString);
            System.IO.File.WriteAllText(pathString + "\\" + newImage.id, JsonConvert.SerializeObject(toSave));
        }

        public static string getAll()
        {
            string pathString = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\polypaint\\offlinefiles";
            System.IO.Directory.CreateDirectory(pathString);
            string[] files = System.IO.Directory.GetFiles(pathString);

            string response = "[";
            files.ToList().ForEach((fileName) =>
            {
                response += System.IO.File.ReadAllText(System.IO.Path.Combine(pathString, fileName)) + ",";
            });

            if (response.Length > 1)
                response = response.Substring(0, response.Length - 1);
            return response + "]";
        }

        internal static List<SerializedStroke> load(string currentImageId)
        {
            string pathString = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\polypaint\\offlinefiles";
            System.IO.Directory.CreateDirectory(pathString);
            string fileContent = System.IO.File.ReadAllText(System.IO.Path.Combine(pathString, currentImageId));
            OfflineFileImage image = JObject.Parse(fileContent).ToObject<OfflineFileImage>();
            return image.shapes;
        }
    }

    class OfflineFileImage
    {
        public string id;
        public string title;
        public string ownerId;
        public string protectionLevel;
        public string fullImageUrl;
        public string password;
        public string thumbnailUrl;
        public List<SerializedStroke> shapes;
    }
}
