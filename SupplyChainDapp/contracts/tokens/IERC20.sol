//SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.7.0 <0.9.0;

//Note:
//no data modification so given as view.
//external functions are meant to be called by other contracts.
	
interface IERC20{
    
	//functions
    function totalSupply() external view returns (uint256);

    function getBalance(address account) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);
    
    function transfer(address recipient, uint256 amount) external returns (bool);

    function approve(address spender, uint256 numTokens) external returns (bool);

    function transferFrom(address spender, address recipient, uint256 amount) external returns (bool);

    //events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval( address indexed recipient, address indexed spender, uint256 value);

}