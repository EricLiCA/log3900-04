import * as multer from 'multer';
import * as multers3 from 'multer-s3';
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
}