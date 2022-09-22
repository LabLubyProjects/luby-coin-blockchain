const LubyCoin = artifacts.require('LubyCoin.sol');

module.exports = function(_deployer) {
  _deployer.deploy(LubyCoin);
};
