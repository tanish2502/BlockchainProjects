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


}
