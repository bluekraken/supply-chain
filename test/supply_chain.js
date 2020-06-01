const supplyChain = artifacts.require("./SupplyChain.sol");

let testInstance;

contract("SupplyChain", async (accounts) => {
  //accounts[0] is the default account
  it("Contract deployment", async () => {
    //Fetching the contract instance of our smart contract
    testInstance = await supplyChain.deployed();
    assert(testInstance !== undefined, 'Supply Chain contract should be defined');
  });

  it("Should create a Manufacturer", async () => {
    try {
      const participantId = await testInstance.createParticipant("Jalfrezi", "JaguarWalkerViolin",
        accounts[1], "Manufacturer");
      assert.ok(true, "A Manufacturer was created.");
    } catch (error) {
      assert.ok(false, "Oops, something went wrong!");
    }
  });

  it("Should create a Supplier", async () => {
    try {
      const participantId = await testInstance.createParticipant("Mother Shipton", "LadderForestGarter",
        accounts[2], "Supplier");
      assert.ok(true, "A Supplier was created.");
    } catch (error) {
      assert.ok(false, "Oops, something went wrong!");
    }
  });

  it("Should create a Consumer", async () => {
    try {
      const participantId = await testInstance.createParticipant("Agnes Nutter", "CarpetJellyStick",
        accounts[3], "Consumer");
      assert.ok(true, "A Consumer was created.");
    } catch (error) {
      assert.ok(false, "Oops, something went wrong!");
    }
  });

  it("Should not create a Consimer", async () => {
    try {
      const participantId = await testInstance.createParticipant("Barnaby Plankton", "GapingPencilCheese",
        accounts[4], "Consumer");
      assert.ok(false, "Oops, something went wrong!");
    } catch (error) {
      assert.ok(true, "A Consimer was not created.");
    }
  });

  it("Should get participant details", async () => {
    try {
      const participant = await testInstance.getParticipantDetails(0);
      assert.equal(participant[0], "Jalfrezi");
      assert.equal(participant[1], accounts[1]);
      assert.equal(participant[2], "Manufacturer");
    } catch (error) {
      assert.ok(false, "Oops, something went wrong!");
    }
  });

  it("Should not get participant details", async () => {
    try {
      const participant = await testInstance.getParticipantDetails(3);
      assert.ok(false, "Oops, something went wrong!");
    } catch (error) {
      assert.ok(true, "Could not get the participant details");
    }
  });
})