//SPDX-License-Identifier: UNLICENSED
pragma solidity >0.7.0 <= 0.9.0;

contract supplyChain{

    uint16 public productId;
    uint16 public participantId;
    uint16 public ownerId;

    struct product{
        uint16 serialNumber;
        string name;
        uint16 price;
        uint32 mfgDate;
        address productOwner;
    }

    mapping(uint16 => product) products;

    struct participant{
        string username;
        string password;
        string participantType;
        address participantAddress;
    }

    mapping(uint16 => participant) participants;

    struct ownership{
        uint16 productId;
        uint16 ownerId;
        uint32 trxTimeStamp;
        address productOwner;
    }

    mapping(uint16 => ownership) ownerships;    //ownership w.r.t owner/supplier by ownerId
    mapping(uint16 => uint16[]) productTrack;   //ownership w.r.t product by productId -> keeps track of the product's movement

    event transferOwnership(uint16 productId);

    function addParticipants(string memory _pName, string memory _pPassword, address _pAddress, string memory _pType) public returns(uint16)
    {
        uint16 userId = participantId++;
        participants[userId].username = _pName;
        participants[userId].password = _pPassword;
        participants[userId].participantType = _pType;
        participants[userId].participantAddress = _pAddress;
        return userId;
    }

    function getParticipants(uint16 _participantId) public view returns(string memory, string memory, address)
    {
        return (participants[_participantId].username, participants[_participantId].participantType, participants[_participantId].participantAddress);
    }

    function addProducts(uint16 _ownerId, uint16 _serialNumber, string memory _name, uint16 _price, uint32 _mfgDate) public returns(uint16)
    {
        require(keccak256(abi.encodePacked(participants[_ownerId].participantType)) == keccak256("Manufacturer"), "Only manufacturers authorised to add product");
        uint16 _productId = productId++;
        products[_productId].serialNumber = _serialNumber;
        products[_productId].name = _name;
        products[_productId].price = _price;
        products[_productId].mfgDate = _mfgDate;
        products[_productId].productOwner = participants[_ownerId].participantAddress;
        return _productId;
    }

    function getProducts(uint16 _productId) public view returns(uint16, string memory, uint16, uint32, address)
    {
        return(products[_productId].serialNumber, products[_productId].name, products[_productId].price, products[_productId].mfgDate, products[_productId].productOwner);
    }

    modifier onlyOwner(uint16 _productId)
    {
        require(msg.sender == products[_productId].productOwner);
        _;
    }

    function newOwner(uint16 _userId1, uint16 _userId2, uint16 _productId) onlyOwner(_productId) public returns(bool)
    {
        participant memory p1 = participants[_userId1];
        participant memory p2 = participants[_userId2];
        uint16 ownershipId = ownerId++;

        if(keccak256(abi.encodePacked(p1.participantType)) == keccak256(abi.encodePacked("Manufacturer")) && keccak256(abi.encodePacked(p2.participantType)) == keccak256(abi.encodePacked("Supplier")))
        {
            ownerships[ownershipId].productId = _productId;
            ownerships[ownershipId].ownerId = _userId2;
            ownerships[ownershipId].trxTimeStamp = uint32(block.timestamp);
            ownerships[ownershipId].productOwner = p2.participantAddress;
            products[_productId].productOwner = p2.participantAddress;
            productTrack[_productId].push(ownershipId);
            emit transferOwnership(_productId);
            return true;
        }
        else if(keccak256(abi.encodePacked(p1.participantType)) == keccak256(abi.encodePacked("Supplier")) && keccak256(abi.encodePacked(p2.participantType)) == keccak256(abi.encodePacked("Supplier")))
        {
            ownerships[ownershipId].productId = _productId;
            ownerships[ownershipId].ownerId = _userId2;
            ownerships[ownershipId].trxTimeStamp = uint32(block.timestamp);
            ownerships[ownershipId].productOwner = p2.participantAddress;
            products[_productId].productOwner = p2.participantAddress;
            productTrack[_productId].push(ownershipId);
            emit transferOwnership(_productId);
            return true;
        }
        else if(keccak256(abi.encodePacked(p1.participantType)) == keccak256(abi.encodePacked("Supplier")) && keccak256(abi.encodePacked(p2.participantType)) == keccak256(abi.encodePacked("Consumer")))
        {
            ownerships[ownershipId].productId = _productId;
            ownerships[ownershipId].ownerId = _userId2;
            ownerships[ownershipId].trxTimeStamp = uint32(block.timestamp);
            ownerships[ownershipId].productOwner = p2.participantAddress;
            products[_productId].productOwner = p2.participantAddress;
            productTrack[_productId].push(ownershipId);
            emit transferOwnership(_productId);
            return true;
        }
        return false;
    }

    //returns all the detail/history for the productId's stages across the supply chain
    function getProvenance(uint16 _productId) external view returns(uint16[] memory)
    {
        return productTrack[_productId];
    }

    function getOwnership(uint16 _registeredId) public view returns(uint16, uint16, uint32, address)
    {
        ownership memory regOwner = ownerships[_registeredId];
        return (regOwner.productId, regOwner.ownerId, regOwner.trxTimeStamp, regOwner.productOwner);
    }

    function authenticateParticipant(uint16 _userId, string memory _username, string memory _password, string memory _userType) public view returns(bool)
    {
        if(keccak256(abi.encodePacked(participants[_userId].participantType)) == keccak256(abi.encodePacked(_userType))) {
            if(keccak256(abi.encodePacked(participants[_userId].username)) == keccak256(abi.encodePacked(_username))) {
                if(keccak256(abi.encodePacked(participants[_userId].password)) == keccak256(abi.encodePacked(_password))) {
                    return (true);
                }
            }
        }
        return false;
    }
}
