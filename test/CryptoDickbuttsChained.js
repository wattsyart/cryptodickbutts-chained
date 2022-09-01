const fs = require('fs');
const { ethers } = require("hardhat");

var Metadata;
var Chained;
var Renderer;
var Encoder;
var Builder;
var Strings;
var Wrapper;
var UriBuilder;
var Random;

describe("Builder", function () {
    before(async () => {       

        var renderer = await ethers.getContractFactory("PixelRenderer");
        var rendererDeployed = await renderer.deploy();
        await rendererDeployed.deployed();
        Renderer = rendererDeployed;

        var encoder = await ethers.getContractFactory("GIFEncoder");
        var encoderDeployed = await encoder.deploy();
        await encoderDeployed.deployed();
        Encoder = encoderDeployed;

        var wrapper = await ethers.getContractFactory("SVGWrapper");
        var wrapperDeployed = await wrapper.deploy();
        await wrapperDeployed.deployed();
        Wrapper = wrapperDeployed;

        var uriBuilder = await ethers.getContractFactory("TokenURIBuilder");
        var uriBuilderDeployed = await uriBuilder.deploy();
        await uriBuilderDeployed.deployed();
        UriBuilder = uriBuilderDeployed;

        var metadata = await ethers.getContractFactory("CryptoDickbuttsMetadata");
        var metadataDeployed = await metadata.deploy();
        await metadataDeployed.deployed();
        Metadata = metadataDeployed;

        var builder = await ethers.getContractFactory("CryptoDickbuttsBuilder");
        var builderDeployed = await builder.deploy();
        await builderDeployed.deployed();
        Builder = builderDeployed;

        var strings = await ethers.getContractFactory("CryptoDickbuttsStrings");
        var stringsDeployed = await strings.deploy();
        await stringsDeployed.deployed();
        Strings = stringsDeployed;

        var random = await ethers.getContractFactory("CryptoDickbuttsRandom");
        var randomDeployed = await random.deploy();
        await randomDeployed.deployed();
        Random = randomDeployed;

        var chained = await ethers.getContractFactory("CryptoDickbuttsChained");
        var chainedDeployed = await chained.deploy();
        await chainedDeployed.deployed();
        Chained = chainedDeployed;
        
        await deployFeatures();
    });

    it("can get tokenURI", async function () {

        await Chained.setMetadata(Metadata.address);
        await Chained.setRenderer(Renderer.address);
        await Chained.setEncoder(Encoder.address);
        await Chained.setBuilder(Builder.address);
        await Chained.setStrings(Strings.address);
        await Chained.setSVGWrapper(Wrapper.address);
        await Chained.setTokenURIBuilder(UriBuilder.address);
        await Chained.setRandom(Random.address);

        var tokenURI = await Chained.tokenURI(946);
        console.log(tokenURI);

        var randomTokenURI = await Chained.randomTokenURI(133713371337);
        console.log(randomTokenURI);
    });
});

async function deployFeatures() {
    var featuresToSet = [];

    const files = fs.readdirSync("./features/");

    files.forEach(function (file) {
        var filePath = `./features/${file}`;
        var index = parseInt(file.substring(0, file.indexOf("_")));
        var buffer = fs.readFileSync(filePath);
        var featureToSet = { index: index, buffer: buffer, name: file };
        featuresToSet.push(featureToSet);
    });

    console.log(`Found ${featuresToSet.length} traits.`);

    const gwei = 10;

    var totalCost = 0;
    for (var i = 0; i < featuresToSet.length; i++) {
        var tx = await Builder.setData(featuresToSet[i].index, featuresToSet[i].buffer);
        const receipt = await tx.wait();
        var cost = (receipt.gasUsed * gwei) * .000000001;
        totalCost += cost;
        console.log(`#${featuresToSet[i].index} (${featuresToSet[i].name}) (${i + 1} / ${featuresToSet.length})`);
    }

    console.log(`Deployed ${featuresToSet.length} features.`);
    console.log(`Total cost in ETH assuming ${gwei} gas: ${totalCost}`);
}
