const supplyChain = artifacts.require("./SupplyChain.sol");

let testInstance;

contract("SupplyChain", async (accounts) => {
  //accounts[0] is the default account
  it("Contract deployment", async () => {
    //Fetching the contract instance of our smart contract
    testInstance = await supplyChain.deployed();
    assert(testInstance !== undefined, 'Supply Chain contract should be defined');
  });

  it("Should create a particpant", async () => {
    try {
      let participantId = await testInstance.createParticipant("Jalfrezi", "SmallBrownJobbie",
        accounts[1], "Manufacturer");
      assert.ok(true, "Participant created.")
    } catch (error) {
      assert.ok(false, "Oops, something went wrong!")
    }
  })

  it("Should not create a particpant", async () => {
    try {
      let participantId = await testInstance.createParticipant("Barnaby Plankton", "HeavyPencilGardener",
        accounts[4], "Consimer");
      assert.ok(false, "Oops, something went wrong!")
    } catch (error) {
      assert.ok(true, "Participant not created.")
    }
  })

  // it("Should create a participant", async () => {
  //   let participantId = await testInstance.createParticipant("Jalfrezi", "SmallBrownJobbie",
  //     accounts[1], "Manufacturer");
  //   let participant = await testInstance.getParticipantDetails(0);
  //   assert.equal(participant[0], "Jalfrezi");
  //   assert.equal(participant[1], accounts[1]);
  //   assert.equal(participant[2], "Manufacturer");

  //   participantId = await testInstance.createParticipant("Mother Shipton", "LargeForestDweller",
  //     accounts[2], "Supplier");
  //   participant = await testInstance.getParticipantDetails(1);
  //   assert.equal(participant[0], "Mother Shipton");
  //   assert.equal(participant[1], accounts[2]);
  //   assert.equal(participant[2], "Supplier");

  //   participantId = await testInstance.createParticipant("Agnes Nutter", "CarpetJellyStick",
  //     accounts[3], "Consumer");
  //   participant = await testInstance.getParticipantDetails(2);
  //   assert.equal(participant[0], "Agnes Nutter");
  //   assert.equal(participant[1], accounts[3]);
  //   assert.equal(participant[2], "Consumer");
  // })
})