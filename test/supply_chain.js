let SupplyChain = artifacts.require("./SupplyChain");

let testInstance;

contract("SupplyChain", function(accounts) {
  //accounts[0] is the default account
  it("Contract deployment", function() {
    //Fetching the contract instance of our smart contract
    return SupplyChain.deployed().then(function(instance) {
      //We save the instance in a global variable and all smart contract functions are called using this
      testInstance = instance;
      assert(testInstance !== undefined, 'Supply Chain contract should be defined');
    });
  });

  it("Should create a participant", function() {
    return testInstance.createParticipant("Mandy", "passwordA", accounts[1], "Manufacturer").then(function(result) {
      return testInstance.getParticipantDetails(0);
    }).then(function(result) {
      assert.equal(result[0], "Mandy");
      assert.equal(result[1], accounts[1]);
      assert.equal(result[2], "Manufacturer");
    })
  })
})