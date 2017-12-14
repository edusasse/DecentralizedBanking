var SafeMath = artifacts.require("./SafeMath.sol");
var DecentralizedBankingToken = artifacts.require("./DecentralizedBankingToken.sol");
var Addresses = artifacts.require("./Addresses.sol");
var Crowdsale = artifacts.require("./Crowdsale.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, DecentralizedBankingToken);
  deployer.deploy(Addresses);
  deployer.link(Addresses, DecentralizedBankingToken);
  deployer.deploy(DecentralizedBankingToken).then(function(){
    return deployer.deploy(
      Crowdsale,
      DecentralizedBankingToken.address,
      web3.eth.blockNumber,
      web3.eth.blockNumber+1000,
      web3.toWei(1, 'ether'),
      1
    ).then(function(){});
  });
};
