const Token = artifacts.require("ESKO");
const Exchange = artifacts.require("LESKOdex");

module.exports = async function (deployer) {
  const accounts = await web3.eth.getAccounts();
  await deployer.deploy(Token);

  const feeAccount = accounts[0];
  const feePercent = 10;

  await deployer.deploy(Exchange, feeAccount, feePercent);
};
