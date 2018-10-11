import { S3Config } from '../configs/databases'
import { S3, config } from 'aws-sdk';

export class s3Communcation {

    private albumBucketName = 'polypaintpro/profile-pictures';    
    private s3: S3;

    constructor(){              
        config.update({ accessKeyId: S3Config.ACCESS_KEY, secretAccessKey: S3Config.SECRET_KEY});
        this.s3 = new S3({
            apiVersion: '2006-03-01',
            params: {Bucket: this.albumBucketName}
        });
    }
    
    public postToS3(imageName: String, image: MimeType): void {
        if (!image) {
          return alert('Please choose a file to upload first.');
        }

        var albumPhotosKey = encodeURIComponent(this.albumBucketName) + '//';
      
        var photoKey = albumPhotosKey + imageName;
        this.s3.upload({
          Key: photoKey,
          Body: image,
          ACL: 'public-read',
          Bucket: this.albumBucketName
        }, (err: Error, data: S3.ManagedUpload.SendData) => {
            if (err){
                return alert('There was an error uploading your photo: ' + err.message);
            }
            
            console.log(data);
            alert('Successfully uploaded photo.');
        });
    }
}