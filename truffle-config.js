require("babel-register");
require("babel-polyfill");
require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");
const { PRIVATE_KEY, GOERLI_API, MAINNET_API, MUMBAI_API } = process.env;

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", //  Match any network id
    },
    goerli: {
      provider: () => new HDWalletProvider(PRIVATE_KEY, GOERLI_API),
      network_id: 599,
      skipDryRun: true,
    },
    ethereum: {
      provider: () => new HDWalletProvider(PRIVATE_KEY, MAINNET_API),
      network_id: 1,
      skipDryRun: true,
    },
    matic: {
      provider: () => new HDWalletProvider(PRIVATE_KEY, MUMBAI_API),
      network_id: 80001,
      skipDryRun: true,
    },
  },
  contracts_directory: "./src/contracts",
  contracts_build_directory: "./src/abis/",
  compilers: {
    solc: {
      version: "0.8.17",
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
