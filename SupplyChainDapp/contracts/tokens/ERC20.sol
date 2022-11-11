// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 <0.9.0;

import "./IERC20.sol";

contract ERC20 is IERC20{

    uint256 public constant _totalSupply = 1000;
    /*
    below mapping:
    1st adress is allowed to spent uint256 amount of tokens to 2nd addresses.
    */
    mapping(address => mapping(address => uint256)) public allowed;

    mapping(address => uint256) public _balance;

    function totalSupply() public override pure returns (uint256)
    {
        return _totalSupply;
    }

    function getBalance() public override view returns (uint256)
    {
        return address(this).balance;
    }

    function allowance(address _owner, address _spender) public override returns (uint256)
    {
        require()
    }
    
    function transfer(address _recipient, uint256 _amount) external returns (bool)
    {
        require()
    }

    function approve(address spender, uint256 numTokens) external returns (bool);

    function transferFrom(address spender, address recipient, uint256 amount) external returns (bool);
}
