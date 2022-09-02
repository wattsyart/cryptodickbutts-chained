const hre = require("hardhat");
const utils = require('../scripts/deploy.js');

const fs = require('fs');
const readline = require('readline');
const gutil = require('gulp-util');

const jsonDiff = require('json-diff')
const gifToPng = require('gif-to-png');
const PNG = require('pngjs').PNG;
const pixelmatch = require('pixelmatch');

describe("Deployments", function () {
    it("deploys all contracts", async function () {

        const { chainId } = await hre.ethers.provider.getNetwork()
        console.log("network: " + chainId);

        // Use explicit gas if running on a real network
        var txOptions;
        if (chainId == 8134646) {
            txOptions = null; // privatenode
        } else if (chainId == 31337) {
            deleteFileIfExists("./scripts/manifest.json");
        } else {
            txOptions = getTxOptions();
        }

        // Deploy to real network w/ hardware wallet HID:
        //
        // Example:
        // --------
        // await utils.deployContracts(hre.ethers, 
        //   false /* quiet */, 
        //   false /* trace */, 
        //   getTxOptions() /* txOptions */, 
        //   "HID_FRESH_ADDRESS_PATH_GOES_HERE" /* hid */, 
        //   null /* signerOverride */
        // );

        // Deploy to real network w/ signer override:
        //
        // Example:
        // --------
        // var signerOverride = new ethers.Wallet("PRIVATE_KEY_NEVER_DO_THIS_HONESTLY", ethers.provider);
        // await utils.deployContracts(hre.ethers, 
        //   false /* quiet */, 
        //   false /* trace */, 
        //   getTxOptions() /* txOptions */, 
        //   null /* hid */, 
        //   signerOverride /* signerOverride */
        // );

        var output = await utils.deployContracts(hre.ethers,
            false /* quiet */,
            false /* trace */,
            txOptions /* txOptions */,
            null /* hid */,
            null /* signerOverride */
        );

        await parityCheck(output["CryptoDickbuttsChained"]);
    });
});

async function parityCheck(contract) {
    const fileStream = fs.createReadStream('./scripts/tokenIds.txt');
    const lines = readline.createInterface({
        input: fileStream,
        crlfDelay: Infinity
    });

    createDirectoryIfNotExists('./scripts/output');
    createDirectoryIfNotExists('./scripts/output/images');
    createDirectoryIfNotExists('./scripts/output/images/frames');
    createDirectoryIfNotExists('./scripts/output/metadata');

    for await (const line of lines) {
        const tokenId = parseInt(line);
        const tokenDataUri = await contract.tokenURI(tokenId);

        // convert base64 tokenURI to JSON
        const pattern = /^data:.+\/(.+);base64,(.*)$/;
        var jsonData = tokenDataUri.match(pattern)[2];
        var jsonBuffer = Buffer.from(jsonData, 'base64');
        var json = jsonBuffer.toString('utf8');

        checkMetadata(tokenId, json);
        await checkImage(json, pattern, tokenId);
    }
}

function checkMetadata(tokenId, json) {
    // write metadata for comparison
    const metadataPath = `./scripts/output/metadata/${tokenId}.json`;
    fs.writeFileSync(metadataPath, json);

    var jsonA = JSON.parse(json);
    delete jsonA["image"];
    delete jsonA["image_data"];

    var assetJson = fs.readFileSync(`./provenance/metadata/${tokenId}.json`, 'utf8');
    if (!assetJson.startsWith("{")) {
        assetJson = "{" + assetJson;
    }

    var jsonB = JSON.parse(assetJson);
    delete jsonB["image"];
    delete jsonB["image_data"];

    var metaDiff = jsonDiff.diff(jsonA, jsonB);
    var metaDeltaPath = `./scripts/output/metadata/${tokenId}_delta.json`;
    deleteFileIfExists(metaDeltaPath);
    if (metaDiff) {
        // create delta JSON if there isn't an exact match, for inspection                        
        fs.writeFileSync(metaDeltaPath, JSON.stringify(metaDiff));
        console.log(gutil.colors.red(metaDeltaPath));
    } else {
        console.log(gutil.colors.green(metadataPath));
    }
}

async function checkImage(json, pattern, tokenId) {
    // convert image URI to GIF buffer
    var imageDataUri = JSON.parse(json).image;
    var imageFormat = imageDataUri.match(pattern)[1];
    var imageData = imageDataUri.match(pattern)[2];
    let imageBuffer = Buffer.from(imageData, 'base64');

    // write GIF buffer to disk for comparison
    const imagePath = `./scripts/output/images/${tokenId}.gif`;
    fs.writeFileSync(imagePath, imageBuffer);
    console.log(gutil.colors.green(imagePath));

    // convert GIF to PNG frames for deltas
    const framePath = `./scripts/output/images/frames/${tokenId}`;
    createDirectoryIfNotExists(framePath);
    await gifToPng(imagePath, framePath);

    // load PNGs for comparison images
    const asset = PNG.sync.read(fs.readFileSync(`./provenance/images/${tokenId}.png`));
    const generated = PNG.sync.read(fs.readFileSync(`./scripts/output/images/frames/${tokenId}/frame1.png`));

    // compare images for exact match
    const { width, height } = asset;
    const diff = new PNG({ width, height });
    const badPixels = pixelmatch(asset.data, generated.data, diff.data, width, height, { threshold: 0 });

    // create delta image if there isn't an exact match, for inspection
    var imageDeltaPath = `./scripts/output/images/${tokenId}_delta.png`;
    deleteFileIfExists(imageDeltaPath);
    if (badPixels != 0) {
        fs.writeFileSync(imageDeltaPath, PNG.sync.write(diff));
        console.log(gutil.colors.red(imageDeltaPath));
    }
}

function getTxOptions(gasLimit) {
    var baseFeePerGas = ethers.BigNumber.from(4).mul(hre.ethers.BigNumber.from(1000000000));
    var priorityFeeInWei = ethers.BigNumber.from(2).mul(hre.ethers.BigNumber.from(1000000000));
    const txOptions = {
        maxPriorityFeePerGas: priorityFeeInWei,
        maxFeePerGas: baseFeePerGas.add(priorityFeeInWei)
    }
    if (gasLimit) {
        txOptions.gasLimit = gasLimit;
    }
    return txOptions;
}

function createDirectoryIfNotExists(path) {
    try {
        return fs.mkdirSync(path)
    } catch (error) {
        if (error.code !== 'EEXIST') throw error
    }
}

function deleteFileIfExists(path) {
    try {
        if (fs.existsSync(path)) {
            fs.unlinkSync(path);
        }
    } catch (error) {
        console.error(gutil.colors.red(error));
    }
}