using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles
{
    class Image
    {
        private string Id;
        private string OwnerId;
        private string Title;
        private string ProtectionLevel;
        private string Password;
        private string ThumbnailUrl;
        private string FullImageUrl;

        public Image()
        {
            this.Id = null;
            this.OwnerId = null;
            this.Title = null;
            this.ProtectionLevel = null;
            this.Password = null;
            this.ThumbnailUrl = null;
            this.FullImageUrl = null;
        }

        public Image(string id, string ownerId, string title, string protectionLevel, string password, string thumbnailUrl, string fullImageUrl)
        {
            this.Id = id;
            this.OwnerId = ownerId;
            this.Title = title;
            this.ProtectionLevel = protectionLevel;
            this.Password = password;
            this.ThumbnailUrl = thumbnailUrl;
            this.FullImageUrl = fullImageUrl;
        }
    }
}
