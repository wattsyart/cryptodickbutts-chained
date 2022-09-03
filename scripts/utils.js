const fs = require('fs');
const gutil = require('gulp-util');

module.exports = {

    random: async function random(contract, seed, outputDir) {
        if(!outputDir) outputDir = './scripts/output/random';
        createDirectoryIfNotExists(outputDir);

        const pattern = /^data:.+\/(.+);base64,(.*)$/;

        if(!seed) seed = parseInt(Math.floor(Math.random() * 9007199254740990) + 1);

        // call contract to get tokenURI        
        var tokenDataUri = await contract.randomTokenURI(seed);
        
        // convert base64 tokenURI to JSON
        var jsonData = tokenDataUri.match(pattern)[2];
        var jsonBuffer = Buffer.from(jsonData, 'base64');
        var json = jsonBuffer.toString('utf8');

        // save metadata
        const metadataPath = `${outputDir}/${seed}.json`;
        fs.writeFileSync(metadataPath, json);
        console.log(gutil.colors.green(metadataPath));

        // convert image URI to GIF buffer
        var imageDataUri = JSON.parse(json).image;
        var imageData = imageDataUri.match(pattern)[2];
        let imageBuffer = Buffer.from(imageData, 'base64');

        // save image
        const imagePath = `${outputDir}/${seed}.gif`;
        fs.writeFileSync(imagePath, imageBuffer);
        console.log(gutil.colors.green(imagePath));
    },

    randomImage: async function randomImage(contract, seed, outputDir) {
        if(!outputDir) outputDir = './scripts/output/random';
        createDirectoryIfNotExists(outputDir);

        const pattern = /^data:.+\/(.+);base64,(.*)$/;

        // call contract to get tokenURI
        if(!seed) seed = parseInt(Math.floor(Math.random() * 9007199254740990) + 1);
        var imageDataUri = await contract.randomImageURI(seed);
        
        // convert image URI to GIF buffer
        var imageData = imageDataUri.match(pattern)[2];
        let imageBuffer = Buffer.from(imageData, 'base64');

        // save image
        const imagePath = `${outputDir}/${seed}.gif`;
        fs.writeFileSync(imagePath, imageBuffer);
        console.log(gutil.colors.green(imagePath));
    }
}

function createDirectoryIfNotExists(path) {
    try {
        return fs.mkdirSync(path)
    } catch (error) {
        if (error.code !== 'EEXIST') throw error
    }
}