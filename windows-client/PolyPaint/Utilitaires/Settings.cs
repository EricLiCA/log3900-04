using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Utilitaires
{
    class Settings
    {
        public const string API_VERSION = "v1";
        public const string IMAGES_PATH = "/images";
        public const string IMAGE_LIKES_PATH = "/imageLikes";
        public const string IMAGE_COMMENTS_PATH = "/imageComments";

        //Tooltips text
        public const string PASSWORD_BUTTON_CHECKED_TOOLTIP = "Remove the password";
        public const string PASSWORD_BUTTON_UNCHECKED_TOOLTIP = "Protect the image with a password";
        public const string LOCK_BUTTON_CHECKED_TOOLTIP = "Make the image public. A public image can be seen by anyone";
        public const string LOCK_BUTTON_UNCHECKED_TOOLTIP = "Make the image private. A private image can be seen only by you";
        public const string LIKE_BUTTON_CHECKED_TOOLTIP = "Dislike this image";
        public const string LIKE_BUTTON_UNCHECKED_TOOLTIP = "Like this image";
    }
}
