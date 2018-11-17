using System;
using System.Collections.Generic;
using System.IO;
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
            Directory.CreateDirectory(pathString);

            string fileContent = File.ReadAllText(Path.Combine(pathString, imageToUpdate.id));
            OfflineFileImage image = JObject.Parse(fileContent).ToObject<OfflineFileImage>();
            image.fullImageUrl = imageToUpdate.fullImageUrl;
            image.title = imageToUpdate.title;
            image.protectionLevel = imageToUpdate.protectionLevel;
            image.password = imageToUpdate.password;
            image.thumbnailUrl = imageToUpdate.thumbnailUrl;

            File.WriteAllText(pathString + "\\" + image.id, JsonConvert.SerializeObject(image));
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
                shapes = new List<string>()
            };

            string pathString = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\polypaint\\offlinefiles";
            Directory.CreateDirectory(pathString);
            File.WriteAllText(pathString + "\\" + newImage.id, JsonConvert.SerializeObject(toSave));
        }

        public static string getAll()
        {
            string pathString = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\polypaint\\offlinefiles";
            Directory.CreateDirectory(pathString);
            string[] files = Directory.GetFiles(pathString);

            string response = "[";
            files.ToList().ForEach((fileName) =>
            {
                response += File.ReadAllText(Path.Combine(pathString, fileName)) + ",";
            });

            if (response.Length > 1)
                response = response.Substring(0, response.Length - 1);
            return response + "]";
        }

        internal static List<string> load(string currentImageId)
        {
            string pathString = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\polypaint\\offlinefiles";
            Directory.CreateDirectory(pathString);
            string fileContent = File.ReadAllText(Path.Combine(pathString, currentImageId));
            OfflineFileImage image = JObject.Parse(fileContent).ToObject<OfflineFileImage>();
            return image.shapes;
        }

        internal static void save(List<string> tosave)
        {
            string pathString = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\polypaint\\offlinefiles";
            Directory.CreateDirectory(pathString);

            string fileContent = File.ReadAllText(Path.Combine(pathString, ServerService.instance.currentImageId));
            OfflineFileImage image = JObject.Parse(fileContent).ToObject<OfflineFileImage>();
            image.shapes = tosave;

            File.WriteAllText(pathString + "\\" + image.id, JsonConvert.SerializeObject(image));
        }

        internal static void saveImage(byte[] obj)
        {
            string path2String = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\polypaint\\previews";
            Directory.CreateDirectory(path2String);
            string file = Path.Combine(path2String, ServerService.instance.currentImageId + ".png");
            File.WriteAllBytes(file, obj);

            string pathString = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\polypaint\\offlinefiles";
            Directory.CreateDirectory(pathString);

            string fileContent = File.ReadAllText(Path.Combine(pathString, ServerService.instance.currentImageId));
            OfflineFileImage image = JObject.Parse(fileContent).ToObject<OfflineFileImage>();
            image.fullImageUrl = file;
            image.thumbnailUrl = file;

            File.WriteAllText(pathString + "\\" + image.id, JsonConvert.SerializeObject(image));
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
        public List<string> shapes;
    }
}
