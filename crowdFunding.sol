//SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.7.0 <0.9.0;

/*
*****[Tested & Working]*****
Crowd Funding Description:
Manager handles the cause of the funding
3 things to be considered
1. target
2. deadline
3. min contribution

collected funds will be collected to the pool(smart contract here), 
once target amount is reached within the stipulated deadline whole amount will be tranferred to the beneficiary.
If not, contibutors can withdraw their respective amount back.
AND
Manager can withdraw ether from the contract only,
when more than 50% of the contributor agrees for the same else manager can't withdraw the collected amount
*/

contract crowdfunding{
    address public manager;
    uint public target;
    uint public deadline;
    uint public minimunContribution;
    uint public raisedAmount;
    uint public numberOfContributors;
    mapping(address => uint) public contributors;

    constructor(uint _target, uint _deadline, uint _minimunContri){
        manager = msg.sender;
        target = _target;
        deadline = block.timestamp + _deadline; //deadline must be in secs
        minimunContribution = _minimunContri;
    }

    //functions
    //contibutors will send ether -> wherever eth transaction is there, make that fn -> payable
    function sendEth() public payable
    {
        require(block.timestamp < deadline, "Deadline has passed!!");
        require(msg.value >= minimunContribution, "Minimum Contribution not met");
        if(contributors[msg.sender] == 0){
            numberOfContributors++;
        }
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    function getContractBalance() public view returns(uint)
    {
        return address(this).balance;
    }

    //send collected ether to manager incluing al necessary checks
    function refund() public
    {
        require(block.timestamp > deadline && raisedAmount >= target);
        require(contributors[msg.sender] > 0);
        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0;
    }

    modifier onlyManger(){
        require(msg.sender==manager,"Only manager can call this function");
        _;
    }

}
