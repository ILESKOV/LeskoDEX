require('babel-register');
require('babel-polyfill');
require('dotenv').config();
const HDWalletProvider = require('truffle-hdwallet-provider-privkey');
const privateKeys = process.env.PRIVATE_KEYS || ""
const INFURA_API_KEY = process.env.INFURA_API_KEY

// const HDWalletProvider = require('@truffle/hdwallet-provider');
// const infuraKey = "7ed1ab3a40f245fe99bf090e6f804126";

// const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim();


module.exports = {
 networks: {
    development:{
      host: "127.0.0.1" ,
      port: 7545 ,
      network_id: "*"//  Match any network id
    },

    // rinkeby:{
    //   provider: function() {
    //     return new HDWalletProvider( privateKeys.split(','), `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`);
    //   },
    //   network_id: 4 ,
    //   gas : 25000000  ,
    //   gasPrice : 10000000000
    // }
    //   kovan: {
    //   provider: function() {
    //     return new HDWalletProvider(
    //       privateKeys.split(','), // Array of account private keys
    //       `https://kovan.infura.io/v3/${process.env.INFURA_API_KEY}`
    //       )
    //   },
    //   gas: 5000000,
    //   gasPrice: 25000000000,
    //   network_id: 42
    // },
        // Useful for deploying to a public network.
    // NB: It's important to wrap the provider as a function.
    // ropsten: {
    //   provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/${infuraKey}`),
    //   network_id: 3,       // Ropsten's id
    //   gas: 5500000,        // Ropsten has a lower block limit than mainnet
    //   confirmations: 2,    // # of confs to wait between deployments. (default: 0)
    //   timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
    //   skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    // },
  },
  contracts_directory: './src/contracts',
  contracts_build_directory: './src/abis/',
  // Configure your compilers
  compilers: {
    solc: {
      optimizer:{
        enabled:true,
        runs:200
      }
    }
  }
}