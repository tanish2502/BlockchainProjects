SPDX-License-Identifier: GPL-3.0

/*
*****[Tested & Working]*****
Lottery Dapp Description:
Enter in the lottery with the minimun amt(1 eth im my case) in the pool
Minimum 3 number of players should be there -> to be checked by Owner/Manager
All the collected amount will be collected at the contract's address
Randomly Player will be chosen as lottery winner
Pool amt at lottery address will be transferred to the winner(winner's address)
Reset contract id, player's array, pool amout at contract's address
Done!!
Note: Participants can transfer the more than 1 time also.
*/

//1.Pragma Derivative
pragma solidity >= 0.7.0 <0.9.0;

//2.Contract Name
contract Lottery{

//3.Data or State Variables
    address public manager;
    address payable[] public players;
    uint public lotteryId;

    constructor(){
        manager = msg.sender;
        lotteryId = 0;
    }

//4.Collection of functions
    function enterLottery() public payable {
        require(msg.value >= 1 ether);
        players.push(payable(msg.sender));
    }

    function getPlayers() public view returns(address payable[] memory){
        return players;
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function getRandomNumber() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function lotteryWinner() public {
        require(msg.sender == manager);
        require(players.length >= 3);
        uint randomIndex = getRandomNumber() % players.length;
        players[randomIndex].transfer(address(this).balance);
        lotteryId++;

        //clear the player's array
        players = new address payable[](0);
    }
//5.Other Items(If required)
}
