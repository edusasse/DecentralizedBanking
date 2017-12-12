var MoneyLoan = artifacts.require("./MoneyLoan.sol");

module.exports = function(deployer) {
  deployer.deploy(MoneyLoan);
};
