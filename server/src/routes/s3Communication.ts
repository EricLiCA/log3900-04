import { S3Config } from '../configs/databases'
var AWS = require('aws-sdk');

export class s3Communcation {

    private albumBucketName = 'polypaintpro/profile-pictures/';    
    private s3 = new AWS.S3({
        apiVersion: '2006-03-01',
        params: {Bucket: this.albumBucketName}
    });

    constructor(){
        AWS.config.update({ accessKeyId: S3Config.ACCESS_KEY, secretAccessKey: S3Config.SECRET_KEY});
              
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
          ACL: 'public-read'
        }).catch((e: Error) => {
            if (e) {
                return alert('There was an error uploading your photo: ' + e.message);
              }
            alert('Successfully uploaded photo.');
        });
    }
}