const erc20Token = artifacts.require("./ERC20Token.sol");
const supplyChain = artifacts.require("./SupplyChain.sol");

module.exports = function(deployer) {
  deployer.deploy(erc20Token, 10000, "TrustQuay Token", 18, "TQT");
  deployer.deploy(supplyChain);
};
