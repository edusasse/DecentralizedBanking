var DecentralizedBankingToken = artifacts.require("./DecentralizedBankingToken.sol");

contract('DecentralizedBankingToken', (accounts) => {

  var creatorAddress = accounts[0];
  var recipientAddress = accounts[1];
  var delegatedAddress = accounts[2];

  it("should contain 10000 DecentralizedBankingToken in circulation", () => {
    return DecentralizedBankingToken.deployed().then((instance) => {
      return instance.totalSupply.call();
    }).then(balance => {
      assert.equal(balance.valueOf(), 10000, "10000 DecentralizedBankingToken are not in circulation");
    });
  });

  it("should contain 10000 DecentralizedBankingToken in the creator balance", () => {
    return DecentralizedBankingToken.deployed().then(instance => {
      return instance.balanceOf.call(creatorAddress);
    }).then(balance => {
      assert.equal(balance.valueOf(), 10000, "10000 wasn't in the creator balance");
    });
  });

  it("should transfer 1000 DecentralizedBankingToken to the recipient balance", () => {
    var decentralizedBankingTokenInstance;
    return DecentralizedBankingToken.deployed().then(instance => {
      decentralizedBankingTokenInstance = instance;
      return decentralizedBankingTokenInstance.transfer(recipientAddress, 1000, {from: creatorAddress});
    }).then(result => {
      return decentralizedBankingTokenInstance.balanceOf.call(recipientAddress);
    }).then(recipientBalance => {
      assert.equal(recipientBalance.valueOf(), 1000, "1000 wasn't in the recipient balance");
      return decentralizedBankingTokenInstance.balanceOf.call(creatorAddress);
    }).then(creatorBalance => {
      assert.equal(creatorBalance.valueOf(), 9000, "9000 wasn't in the creator balance");
    });
  });

  it("should approve 500 DecentralizedBankingToken to the delegated balance", () => {
    var decentralizedBankingTokenInstance;
    return DecentralizedBankingToken.deployed().then(instance => {
      decentralizedBankingTokenInstance = instance;
      return decentralizedBankingTokenInstance.approve(delegatedAddress, 500, {from: creatorAddress});
    }).then(result => {
      return decentralizedBankingTokenInstance.allowance.call(creatorAddress, delegatedAddress);
    }).then(delegatedAllowance => {
      assert.equal(delegatedAllowance.valueOf(), 500, "500 wasn't approved to the delegated balance");
    });
  });

  it("should transfer 200 DecentralizedBankingToken from the creator to the alt recipient via the delegated address", () => {
    var decentralizedBankingTokenInstance;
    return DecentralizedBankingToken.deployed().then(instance => {
      decentralizedBankingTokenInstance = instance;
      return decentralizedBankingTokenInstance.transferFrom(creatorAddress, recipientAddress, 200, {from: delegatedAddress});
    }).then(result => {
      return decentralizedBankingTokenInstance.balanceOf.call(recipientAddress);
    }).then(recipientBalance => {
      assert.equal(recipientBalance.valueOf(), 1200, "1200 wasn't in the recipient balance");
      return decentralizedBankingTokenInstance.allowance.call(creatorAddress, delegatedAddress);
    }).then(delegatedAllowance => {
      assert.equal(delegatedAllowance.valueOf(), 300, "300 wasn't set as the delegated balance");
    });
  });

});
