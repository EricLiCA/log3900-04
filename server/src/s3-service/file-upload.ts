const multer = require('multer');
const multerS3 = require('multer-s3');
const aws = require('aws-sdk');

aws.config.update({
    secretAccessKey: "ILxZqkV1XH2SYOoxyA8/+SAHWVygmSl2oy+QcHXs", // Not working key, Your SECRET ACCESS KEY from AWS should go here, never share it!!!
    accessKeyId: "AKIAIY6LRNEXXNRDGAOQ", // Not working key, Your ACCESS KEY ID from AWS should go here, never share it!!!
    region: 'us-east-1' // region of your bucket
});

const s3 = new aws.S3();