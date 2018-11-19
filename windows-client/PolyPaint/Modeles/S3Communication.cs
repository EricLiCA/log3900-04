using Amazon;
using Amazon.S3;
using Amazon.S3.Transfer;
using PolyPaint.Services;
using PolyPaint.Utilitaires;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PolyPaint.Modeles
{
    class S3Communication
    {
        private static IAmazonS3 client;
        private const string profileBucketName = Settings.PROFILE_IMAGE_BUCKET;
        private static readonly RegionEndpoint bucketRegion = RegionEndpoint.USEast1;
        private static Amazon.Runtime.BasicAWSCredentials awsCredentials = new Amazon.Runtime.BasicAWSCredentials(Settings.aws_access_key_id, Settings.aws_secret_access_key);
        public S3Communication() { }
        public async Task UploadProfileImageAsync(String location)
        {
            try
            {
                client = new AmazonS3Client(awsCredentials, bucketRegion);
                var fileTransferUtility = new TransferUtility(client);

                // Option 1. Upload a file. The file name is used as the object key name.
                await fileTransferUtility.UploadAsync(location, profileBucketName, ServerService.instance.user.id);

            }
            catch (AmazonS3Exception e)
            {
                Console.WriteLine("Error encountered on server. Message:'{0}' when writing an object", e.Message);
            }
            catch (Exception e)
            {
                Console.WriteLine("Unknown encountered on server. Message:'{0}' when writing an object", e.Message);
            }

        }

        public async Task UploadImageAsync(string location, string imageId)
        {
            try
            {
                client = new AmazonS3Client(awsCredentials, bucketRegion);
                var fileTransferUtility = new TransferUtility(client);

                // Option 1. Upload a file. The file name is used as the object key name.
                await fileTransferUtility.UploadAsync(location, Settings.GALLERY_IMAGE_BUCKET, imageId);

            }
            catch (AmazonS3Exception e)
            {
                Console.WriteLine("Error encountered on server. Message:'{0}' when writing an object", e.Message);
            }
            catch (Exception e)
            {
                Console.WriteLine("Unknown encountered on server. Message:'{0}' when writing an object", e.Message);
            }

        }
    }
}
