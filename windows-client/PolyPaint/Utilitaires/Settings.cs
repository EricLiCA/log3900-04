using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Utilitaires
{
    class Settings
    {
        public const string SERVER_IP = "http://localhost:3000/";
        //public const string SERVER_IP = "http://ec2-34-200-247-233.compute-1.amazonaws.com
        public const string SERVER_STATUS_PATH = "/status";
        public const string API_VERSION = "v2";
        public const string IMAGES_PATH = "/images";
        public const string IMAGES_BY_OWNER_ID_PATH = "/imagesByOwnerId";
        public const string IMAGES_PUBLIC_EXCEPT_MINE = "/imagesPublicExceptMine";
        public const string IMAGE_LIKES_PATH = "/imageLikes";
        public const string IMAGE_COMMENTS_PATH = "/imageComments";
        public const string USERS_PATH = "/users";
        public const string SESSION_PATH = "/sessions";
        public const string FRIENDS_PATH = "/friendships";
        public const string USERS_EXCEPT_FRIENDS_PATH = "/usersExceptFriends";
        public const string PENDING_FRIEND_REQUEST_PATH = "/pendingFriendRequest";
        public const string URL_TO_PROFILE_IMAGES = "https://s3.amazonaws.com/polypaintpro/profile-pictures/";
        public const string PROFILE_IMAGE_BUCKET = "polypaintpro/profile-pictures";

        public const string DEFAULT_PROFILE_IMAGE = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjqmTWoUhezVh6rd7F0DYqkpqDGAwbYoC_hEfi0nphYL1h08gCkA";
        public const string PENDING_FRIEND_REQUEST_BY_REQUESTER_ID_PATH = "/pendingFriendRequestByRequesterId";
        //Tooltips text
        public const string PASSWORD_BUTTON_CHECKED_TOOLTIP = "Remove the password";
        public const string PASSWORD_BUTTON_UNCHECKED_TOOLTIP = "Protect the image with a password";
        public const string LOCK_BUTTON_CHECKED_TOOLTIP = "Make the image public. A public image can be seen by anyone";
        public const string LOCK_BUTTON_UNCHECKED_TOOLTIP = "Make the image private. A private image can be seen only by you";
        public const string LIKE_BUTTON_CHECKED_TOOLTIP = "Dislike this image";
        public const string LIKE_BUTTON_UNCHECKED_TOOLTIP = "Like this image";

        //Credentials
        public const string aws_access_key_id = "AKIAIZN6KZDRICBY76VA";
        public const string aws_secret_access_key = "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";
        
    }
}
