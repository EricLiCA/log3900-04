const express = require("express");
const router = express.Router();
const uploadMulter = require('../s3-service/multer-upload');

const singleUpload = uploadMulter.single('image')

router.post('/image-upload', function(req, res) {
  singleUpload(req, res, function(err, some) {
    if (err) {
      return res.status(422).send({errors: [{title: 'Image Upload Error', detail: err.message}] });
    }

    return res.json({'imageUrl': req.file.location});
  });
})

module.exports = router;