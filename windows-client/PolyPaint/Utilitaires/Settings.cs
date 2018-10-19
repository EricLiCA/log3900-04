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
        public const string API_VERSION = "v2";
        public const string IMAGES_PATH = "/images";
        public const string IMAGE_LIKES_PATH = "/imageLikes";
        public const string IMAGE_COMMENTS_PATH = "/imageComments";
        public const string USERS_PATH = "/users";
        public const string SESSION_PATH = "/sessions";
        public const string FRIENDS_PATH = "/friendships";
        public const string USERS_EXCEPT_FRIENDS_PATH = "/usersExceptFriends";
        public const string PENDING_FRIEND_REQUEST_PATH = "/pendingFriendRequest";

        public const string DEFAULT_PROFILE_IMAGE = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjqmTWoUhezVh6rd7F0DYqkpqDGAwbYoC_hEfi0nphYL1h08gCkA";
        public const string PENDING_FRIEND_REQUEST_BY_REQUESTER_ID_PATH = "/pendingFriendRequestByRequesterId";
    }
}
