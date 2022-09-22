const TransactionLedger = artifacts.require('TransactionLedger.sol');

module.exports = function(_deployer) {
  _deployer.deploy(TransactionLedger);
};
