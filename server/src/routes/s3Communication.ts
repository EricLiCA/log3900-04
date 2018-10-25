import { S3Config } from '../configs/databases'
import { S3, config } from 'aws-sdk';
import express = require('express');
import * as fs from 'fs';

export class s3Communcation {

    private albumBucketName = 'polypaintpro/profile-pictures';    
    private s3: S3;

    constructor(){              
        config.update({ accessKeyId: S3Config.ACCESS_KEY, secretAccessKey: S3Config.SECRET_KEY});
        this.s3 = new S3({
            apiVersion: '2006-03-01',
            params: {Bucket: this.albumBucketName}
        });
        console.log(this.s3);
    }
    
    public async putToS3(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        if (!req) {
          return alert('Please choose a file to upload first.');
        }

        const albumPhotosKey = encodeURIComponent(this.albumBucketName) + '//';
        const photoKey = albumPhotosKey + req.body;
        fs.readFile(req.body, function(err, data) {
            if (err) { throw err; }

            this.s3.putObject({
            Key: photoKey,
            Body: data,
            ACL: 'public-read',
            Bucket: this.albumBucketName
            }, (err: Error, data: S3.ManagedUpload.SendData) => {
                if (err){
                    return alert('There was an error uploading your photo: ' + err.message);
                }
                
                console.log(data);
                alert('Successfully uploaded photo.');
            });
        });
    }
}