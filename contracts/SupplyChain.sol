pragma solidity ^0.5.16;

contract SupplyChain {
    uint32 public p_id = 0;   // Product ID
    uint32 public u_id = 0;   // Participant ID
    uint32 public r_id = 0;   // Registration ID

    struct product {
        string modelNumber;
        string partNumber;
        string serialNumber;
        address productOwner;
        uint32 cost;
        uint32 mfgTimeStamp;
    }

    mapping(uint32 => product) public products;

    struct participant {
        string userName;
        string password;
        string participantType;
        address participantAddress;
    }
    mapping(uint32 => participant) public participants;

    struct registration {
        uint32 productId;
        uint32 ownerId;
        uint32 trxTimeStamp;
        address productOwner;
    }
    mapping(uint32 => registration) public registrations; // Registrations by Registration ID (r_id)
    mapping(uint32 => uint32[]) public productTrack;  // Registrations by Product ID (p_id) / Movement track for a product

    event Transfer(uint32 productId);

    function createParticipant(string memory _name, string memory _pass, address _pAdd, string memory _pType)
        public
        returns (uint32)
    {
        // Check participant type is 'Manufacturer', 'Supplier' or 'Consumer'
        bytes32 participantType = keccak256(abi.encodePacked(_pType));
        require(participantType == keccak256("Manufacturer") ||
            participantType == keccak256("Supplier") ||
            participantType == keccak256("Consumer"),
            "Participant type must be 'Manufacturer', 'Supplier' or 'Consumer'"
        );

        uint32 userId = u_id++;
        participants[userId].userName = _name;
        participants[userId].password = _pass;
        participants[userId].participantAddress = _pAdd;
        participants[userId].participantType = _pType;

        return userId;
    }

    function getParticipantDetails(uint32 _p_id) public view returns (string memory, address, string memory) {
        return (
            participants[_p_id].userName,
            participants[_p_id].participantAddress,
            participants[_p_id].participantType
        );
    }

    function addRegistration(uint32 _productId, address _productOwner, uint32 _ownerId, uint32 _timeStamp)
        private
        returns (bool)
    {
        uint32 registrationId = r_id++;

        registrations[registrationId].productId = _productId;
        registrations[registrationId].productOwner = _productOwner;
        registrations[registrationId].ownerId = _ownerId;
        registrations[registrationId].trxTimeStamp = _timeStamp;
        productTrack[_productId].push(registrationId);
        emit Transfer(_productId);

        return (true);

    }

    function createProduct(
        uint32 _ownerId,
        string memory _modelNumber,
        string memory _partNumber,
        string memory _serialNumber,
        uint32 _productCost
    )
        public
        returns (uint32)
    {
        if (keccak256(abi.encodePacked(participants[_ownerId].participantType)) == keccak256("Manufacturer")) {
            uint32 productId = p_id++;

            products[productId].modelNumber = _modelNumber;
            products[productId].partNumber = _partNumber;
            products[productId].serialNumber = _serialNumber;
            products[productId].cost = _productCost;
            products[productId].productOwner = participants[_ownerId].participantAddress;
            products[productId].mfgTimeStamp = uint32(now);

            addRegistration(productId, products[productId].productOwner, _ownerId, products[productId].mfgTimeStamp);

            return productId;
        }

       return 0;
    }

    modifier onlyOwner(uint32 _productId) {
         require(msg.sender == products[_productId].productOwner, 'Only the product owner can do this');
         _;
    }

    function getProductDetails(uint32 _productId)
        public
        view
        returns (string memory, string memory, string memory, uint32, address, uint32)
    {
        return (
            products[_productId].modelNumber,
            products[_productId].partNumber,
            products[_productId].serialNumber,
            products[_productId].cost,
            products[_productId].productOwner,
            products[_productId].mfgTimeStamp
        );
    }

    function transferToOwner(uint32 _user1Id, uint32 _user2Id, uint32 _prodId)
        public
        onlyOwner(_prodId)
        returns (bool)
    {
        participant memory p1 = participants[_user1Id];
        participant memory p2 = participants[_user2Id];

        bytes32 p1Type = keccak256(abi.encodePacked(p1.participantType));
        bytes32 p2Type = keccak256(abi.encodePacked(p2.participantType));

        if (p1Type == keccak256("Manufacturer") && p2Type == keccak256("Supplier")) {
            products[_prodId].productOwner = p2.participantAddress;
            addRegistration(_prodId, p2.participantAddress, _user2Id, uint32(now));

            return (true);
        }
        else if (p1Type == keccak256("Supplier") && p2Type == keccak256("Supplier")) {
            products[_prodId].productOwner = p2.participantAddress;
            addRegistration(_prodId, p2.participantAddress, _user2Id, uint32(now));

            return (true);
        }
        else if (p1Type == keccak256("Supplier") && p2Type == keccak256("Consumer")) {
            products[_prodId].productOwner = p2.participantAddress;
            addRegistration(_prodId, p2.participantAddress, _user2Id, uint32(now));

            return (true);
        }

        return (false);
    }

   function getProductTrack(uint32 _prodId) external view returns (uint32[] memory) {

       return productTrack[_prodId];
    }

    function getRegistrationDetails(uint32 _regId) public view returns (uint32, uint32, address, uint32) {
        registration memory r = registrations[_regId];

        return (r.productId, r.ownerId, r.productOwner, r.trxTimeStamp);
    }

    function authenticateParticipant(uint32 _uid, string memory _uname, string memory _pass, string memory _utype) public view returns (bool) {
        if(keccak256(abi.encodePacked(participants[_uid].participantType)) == keccak256(abi.encodePacked(_utype))) {
            if(keccak256(abi.encodePacked(participants[_uid].userName)) == keccak256(abi.encodePacked(_uname))) {
                if(keccak256(abi.encodePacked(participants[_uid].password)) == keccak256(abi.encodePacked(_pass))) {
                    return (true);
                }
            }
        }

        return (false);
    }
}