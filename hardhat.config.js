require("@nomiclabs/hardhat-etherscan");
require("@nomicfoundation/hardhat-chai-matchers")

require("hardhat-gas-reporter");

// require("./tasks/tasks.js");

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
  defaultNetwork: "hardhat",
  networks: {    
    hardhat: {
      gas: "auto",
      blockGasLimit: 900_000_000,
      initialBaseFeePerGas: 0,
      timeout: 43200000
    },
    privatenode: {
      url: "http://127.0.0.1:8545",
      accounts: ["0xb0a587bc9681a7333763f84c3b90a4d58bd01b5fb0635ac16187f6f55e792a57"],
      gasPrice: "auto",
      gas: "auto",
      timeout: 43200000
    },
    rinkeby: {
      url: "RINKEBY_RPC_URL_GOES_HERE",
      gasPrice: "auto",
      gas: "auto",
      gasMultiplier: 1,
      timeout: 43200000
    }, 
    mainnet: {
      url: "MAINNET_RPC_URL_GOES_HERE",
      gasPrice: "auto",
      gas: "auto",
      gasMultiplier: 1,
      timeout: 43200000
    }
  },
  etherscan: {
    apiKey: "ETHERSCAN_API_KEY_GOES_HERE"
  },
  solidity: {
    version: "0.8.13",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1
      }
    }
  },
  mocha: {
    timeout: 2000000000
  },
  gasReporter: {
    enabled: true,
    currency: 'ETH',
    gasPriceApi: 'https://api.etherscan.io/api?module=proxy&action=eth_gasPrice'
  }
};