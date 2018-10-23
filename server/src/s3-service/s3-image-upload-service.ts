import * as multer from 'multer';
import * as multerS3 from 'multer-s3';
import * as aws from 'aws-sdk';

export class S3ImageUploadService {
    
    public s3UploadServiceInstance: aws.S3;

    private constructor() {
        aws.config.update({
            secretAccessKey: "fefe",
            accessKeyId: "",
            region: 'us-east-1'
        })

        this.s3UploadServiceInstance = new aws.S3();
    }

    public upload(): void {
        storage: multerS3({
            s3: this.s3UploadServiceInstance,
            bucket: 'medium-test',
            acl: 'public-read',
            metadata: function (req, file, cb) {
              cb(null, {fieldName: file.fieldname});
            },
            key: function (req, file, cb) {
              cb(null, Date.now().toString())
            }
          })
    }
}