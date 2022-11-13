// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 <0.9.0;

import "./IERC20.sol";

contract ERC20 is IERC20{

    string public constant name = "AltCoin";
    string public constant coin = "AC";
    uint256 public constant decimal = 18;
    uint256 public constant _totalSupply = 1000;
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    /*
    below mapping:
    1st adress is allowed to spent uint256 amount of tokens to 2nd addresses.
    */
    mapping(address => mapping(address => uint256)) public allowed;

    mapping(address => uint256) public _balance;

    constructor(){
        _balance[msg.sender] = _totalSupply;
    }

    function totalSupply() public override pure returns (uint256)
    {
        return _totalSupply;
    }

    function getBalance() public override view returns (uint256)
    {
        return address(this).balance;
    }

    function allowance(address _owner, address _delegate) public override view returns (uint256)
    {
        return allowed[_owner][_delegate];
    }
    
    function transfer(address _recipient, uint256 _amount) public override returns (bool)
    {
        require(_balance[msg.sender] >= _amount);
        _balance[msg.sender] -= _amount;
        _balance[_recipient] += _amount;
        emit Transfer(msg.sender, _recipient, _amount);
        return true;
    }

    function approve(address _delegate, uint256 _numTokens) public override returns (bool)
    {
        allowed[msg.sender][_delegate] = _numTokens;
        emit Approval(_delegate, msg.sender, _numTokens);
        return true;
    }

    function transferFrom(address _spender, address _recipient, uint256 _amount) public override returns (bool)
    {
        uint256 _allowance = allowed[_spender][msg.sender];
        require(_balance[_spender] >= _amount && _balance[_spender] >= _allowance, "Insufficient funds to transfer from Sender");
        _balance[_spender] -= _amount;
        _balance[_recipient] += _amount;
        if(_allowance < MAX_UINT256){
            allowed[_spender][msg.sender] -= _amount;
        }
        emit Transfer(_spender, _recipient, _amount);
        return true;
    }
}
