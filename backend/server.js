
//Install express server
const express = require('express');
const path = require('path');
const cors = require('cors');
const fs = require('fs');
const multer = require('multer');

const app = express();

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'public/green-text-nft/');
    },
    filename: function (req, file, cb) {
        cb(null, file.originalname);
    }
});
const upload = multer({ storage: storage });

// Serve only the static files form the dist directory
app.use(express.static(__dirname + '/public/'));

var corsOptions = {
    origin: '*',
    allowedHeaders: ['Content-Type', 'Authorization', 'Content-Length', 'X-Requested-With', 'Accept', 'Origin', 'Access-Control-Allow-Headers'],
    methods: ['GET', 'POST', 'DELETE', 'OPTIONS']
}
app.options('*', cors());
app.use(cors(corsOptions));

// Route for file upload
app.post('/green-text-nft', upload.single('image'), function (req, res) {
    res.send('File uploaded successfully!');
});

app.get('/*', function (req, res) {
    res.sendFile(path.join(__dirname + '/public/index.html'));
});

app.listen(process.env.PORT || 80).on("error", function (err) {
    console.log(err);
});
