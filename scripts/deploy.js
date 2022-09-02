const fs = require('fs');
const { LedgerSigner } = require("@ethersproject/hardware-wallets");

module.exports = {
  deployContracts: deployContracts
}

var signer;

// https://docs.ethers.io/v5/api/contract/contract-factory/
async function deployContract(manifest, ethers, contractName, quiet, trace, txOptions, hid, signerOverride) {

  if (!signer && signerOverride) {
    if(!quiet) console.log("using signer override");
    signer = signerOverride;
  }

  if (hid && !signer) {
    signer = new LedgerSigner(ethers.provider, "hid", hid);
    // ethers ledger plugin *STILL* doesn't have EIP-1559 support, so we have to drop to legacy transactions
    // see: https://github.com/ethers-io/ethers.js/issues/2078    
    txOptions.type = 1;
    var maxFeePerGas = txOptions.maxFeePerGas;
    delete txOptions["maxFeePerGas"];
    delete txOptions["maxPriorityFeePerGas"];
    txOptions.gasPrice = maxFeePerGas;
  } else if (!signer) {
    [owner] = await ethers.getSigners();
    signer = owner;
  }

  if (manifest[contractName] && !trace) {
    var factory = await ethers.getContractFactory(contractName);
    var output = factory.attach(manifest[contractName]);
    output = output.connect(signer);
    if(!quiet) console.log(`${contractName} already deployed to ${output.address}`);
    return output;
  }

  if(!quiet) console.log("signer:", (await signer.getAddress()).toString());
  if(!quiet) console.log("balance:", (await signer.getBalance()).toString());

  const contract = await (await ethers.getContractFactory(contractName)).connect(signer);
  if (trace) {
    // https://docs.ethers.io/v5/api/utils/transactions/#UnsignedTransaction
    var unsignedTx = await contract.getDeployTransaction(txOptions);
    if (!quiet) console.log(`${contractName} created unsigned transaction`);
    return unsignedTx;
  } else {
    var deployed = await contract.deploy(txOptions);
    await deployed.deployed();
    if (!quiet) console.log(`${contractName} deployed to ${deployed.address}`);
    manifest[contractName] = deployed.address;
    fs.writeFileSync("./scripts/manifest.json", JSON.stringify(manifest));
    return deployed;
  }
}

async function deployContracts(ethers, quiet, trace, txOptions, hid, signerOverride) {

  if (hid && signerOverride) {
    console.log("ERROR: cannot specify both an HID and a signer override!");
    return;
  }

  if (!quiet) quiet = false;
  if (!trace) trace = false;

  console.log("quiet: " + quiet);
  console.log("trace: " + trace);

  if (txOptions) {
    console.log("txOptions: " + JSON.stringify(txOptions));
  }
  if (hid) {
    console.log("hid: " + hid);
  }
  if (signerOverride) {
    console.log("signerOverride: " + signerOverride.address);
  }

  console.log();

  if (!txOptions) txOptions = {};

  var output = {};

  const manifestPath = "./scripts/manifest.json";
  if (!fs.existsSync(manifestPath)) {
    console.log("creating ./scripts/manifest.json");
    fs.writeFileSync(manifestPath, "{}");
  }

  var manifest = JSON.parse(fs.readFileSync("./scripts/manifest.json").toString('utf8'));

  output["GIFEncoder"] = await deployContract(manifest, ethers, "GIFEncoder", quiet, trace, txOptions, hid, signerOverride);
  output["PixelRenderer"] = await deployContract(manifest, ethers, "PixelRenderer", quiet, trace, txOptions, hid, signerOverride);
  output["SVGWrapper"] = await deployContract(manifest, ethers, "SVGWrapper", quiet, trace, txOptions, hid, signerOverride);
  output["TokenURIBuilder"] = await deployContract(manifest, ethers, "TokenURIBuilder", quiet, trace, txOptions, hid, signerOverride);

  output["CryptoDickbuttsMetadata"] = await deployContract(manifest, ethers, "CryptoDickbuttsMetadata", quiet, trace, txOptions, hid, signerOverride);
  output["CryptoDickbuttsBuilder"] = await deployContract(manifest, ethers, "CryptoDickbuttsBuilder", quiet, trace, txOptions, hid, signerOverride);
  output["CryptoDickbuttsStrings"] = await deployContract(manifest, ethers, "CryptoDickbuttsStrings", quiet, trace, txOptions, hid, signerOverride);
  output["CryptoDickbuttsRandom"] = await deployContract(manifest, ethers, "CryptoDickbuttsRandom", quiet, trace, txOptions, hid, signerOverride);
  output["CryptoDickbuttsChained"] = await deployContract(manifest, ethers, "CryptoDickbuttsChained", quiet, trace, txOptions, hid, signerOverride);
  
  const contract = output["CryptoDickbuttsBuilder"];
  
  await deployFeatures(contract, quiet, txOptions);
  await deployDeltas(contract, quiet, txOptions);
  await setDependencies(output, quiet, txOptions);

  return output;
}

async function setDependencies(output, quiet, txOptions) {
  var tx;
  
  tx = await output["CryptoDickbuttsChained"].setEncoder(output["GIFEncoder"].address, txOptions);  
  await tx.wait();
  if(!quiet) console.log(`set encoder to ${output["GIFEncoder"].address}`);

  tx = await output["CryptoDickbuttsChained"].setRenderer(output["PixelRenderer"].address, txOptions);
  await tx.wait();
  if(!quiet) console.log(`set renderer to ${output["PixelRenderer"].address}`);

  tx = await output["CryptoDickbuttsChained"].setSVGWrapper(output["SVGWrapper"].address, txOptions);
  await tx.wait();
  if(!quiet) console.log(`set SVG wrapper to ${output["SVGWrapper"].address}`);

  tx = await output["CryptoDickbuttsChained"].setTokenURIBuilder(output["TokenURIBuilder"].address, txOptions);
  await tx.wait();
  if(!quiet) console.log(`set token URI builder to ${output["TokenURIBuilder"].address}`);

  tx = await output["CryptoDickbuttsChained"].setMetadata(output["CryptoDickbuttsMetadata"].address, txOptions);
  await tx.wait();
  if(!quiet) console.log(`set metadata to ${output["CryptoDickbuttsMetadata"].address}`);

  tx = await output["CryptoDickbuttsChained"].setBuilder(output["CryptoDickbuttsBuilder"].address, txOptions);
  await tx.wait();
  if(!quiet) console.log(`set builder to ${output["CryptoDickbuttsBuilder"].address}`);

  tx = await output["CryptoDickbuttsChained"].setStrings(output["CryptoDickbuttsStrings"].address, txOptions);
  await tx.wait();
  if(!quiet) console.log(`set strings to ${output["CryptoDickbuttsStrings"].address}`);

  tx = await output["CryptoDickbuttsChained"].setRandom(output["CryptoDickbuttsRandom"].address, txOptions);
  await tx.wait();
  if(!quiet) console.log(`set random to ${output["CryptoDickbuttsRandom"].address}`);
}

async function deployFeatures(Builder, quiet, txOptions) {
  var featuresToSet = [];

  const files = fs.readdirSync("./features/");

  files.forEach(function (file) {
      var filePath = `./features/${file}`;
      var index = parseInt(file.substring(0, file.indexOf("_")));
      var buffer = fs.readFileSync(filePath);
      var featureToSet = { index: index, buffer: buffer, name: file };
      featuresToSet.push(featureToSet);
  });

  if(!quiet) console.log(`Found ${featuresToSet.length} traits.`);

  const gwei = 10;

  var totalCost = 0;
  for (var i = 0; i < featuresToSet.length; i++) {
      var tx = await Builder.setData(featuresToSet[i].index, featuresToSet[i].buffer, txOptions);
      const receipt = await tx.wait();
      var cost = (receipt.gasUsed * gwei) * .000000001;
      totalCost += cost;
      if(!quiet) console.log(`#${featuresToSet[i].index} (${featuresToSet[i].name}) (${i + 1} / ${featuresToSet.length})`);
  }

  if(!quiet) console.log(`Deployed ${featuresToSet.length} features.`);
  if(!quiet) console.log(`Total cost in ETH assuming ${gwei} gas: ${totalCost}`);
}

async function deployDeltas(Builder, quiet, txOptions) {
  var deltasToSet = [];

  const files = fs.readdirSync("./deltas/");

  files.forEach(function (file) {
      var filePath = `./deltas/${file}`;
      var index = parseInt(file.substring(0, file.indexOf(".bin")));      
      var buffer = fs.readFileSync(filePath);
      var deltaToSet = { index: index, buffer: buffer, name: file };
      deltasToSet.push(deltaToSet);
  });

  if(!quiet) console.log(`Found ${deltasToSet.length} deltas.`);

  const gwei = 10;

  var totalCost = 0;
  for (var i = 0; i < deltasToSet.length; i++) {
      var tx = await Builder.setDelta(deltasToSet[i].index, deltasToSet[i].buffer, txOptions);
      const receipt = await tx.wait();
      var cost = (receipt.gasUsed * gwei) * .000000001;
      totalCost += cost;
      if(!quiet) console.log(`#${deltasToSet[i].index} (${deltasToSet[i].name}) (${i + 1} / ${deltasToSet.length})`);
  }

  if(!quiet) console.log(`Deployed ${deltasToSet.length} deltas.`);
  if(!quiet) console.log(`Total cost in ETH assuming ${gwei} gas: ${totalCost}`);
}