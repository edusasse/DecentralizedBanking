pragma solidity ^0.4.18; 

import './ERC20.sol';
import './ERC223.sol';
import './SafeERC20.sol';
import './SafeMath.sol';
import "./Addresses.sol";
import './Token.sol';
import "./ERC223ReceivingContract.sol";

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract DecentralizedBankingToken is Token("DBNK", "Decentralized Banking", 18, 10000), ERC20, ERC223 {
    
    using Addresses for address;
    using SafeERC20 for ERC20;
    using SafeMath for uint256;

    address public owner; 
    
    mapping(address => uint256) balances; 
    mapping(address => mapping(address => uint256)) allowed; 
    
    function DecentralizedBankingToken() { 
        owner = msg.sender; 
    }
    
    function createTokens() payable { 
        require(msg.value > 0); 
        
        uint256 tokens = msg.value.mul(RATE); 
        balances[msg.sender] = balances[msg.sender].add(tokens); 
        _totalSupply = _totalSupply.add(tokens);
        
        owner.transfer(msg.value);
    }

    function balance0f(address _owner) public view returns (uint256 balance) { 
        return balances[_owner]; 
    }
    
    function transfer(address _to, uint _value) public returns (bool success) { 
        require( 
            balances[msg.sender] >= _value 
            && _value > 0 ); 
            
        balances[msg.sender] = balances[msg.sender].sub(_value); 
        balances[_to] = balances[_to].add(_value); 
        Transfer(msg.sender, _to, _value);
        
        return true; 
    }

    function transfer(address _to, uint _value, bytes _data) public returns (bool) {
        if (_value > 0 &&
            _value <= _balanceOf[msg.sender]) {

            if (_to.isContract()) {
              ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
              _contract.tokenFallback(msg.sender, _value, _data);
            }

            _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
            _balanceOf[_to] = _balanceOf[_to].add(_value);

            return true;
        }
        return false;
    }
    
    function transferFrom(address _from, address _to, uint _value) returns (bool success) {
        require( 
            allowed[_from][msg.sender] >= _value 
            && balances[_from] >= _value 
            && _value > 0 
        );
        
        balances[_from] = balances[_from].sub(_value); 
        balances[_to] = balances[_to].add(_value); 
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value); 
        
        return true; 
    }
    
    function approve(address _spender, uint _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value; 
        Approval(msg.sender, _spender, _value); 
        
        return true; 
    }
    
    function allowance(address _owner, address _spender) constant returns (uint remaining){
        return allowed[_owner][_spender]; 
    } 
    
    event Transfer(address indexed _from, address indexed _to, uint _value); 
    event Approval(address indexed _owner, address indexed _spender, uint _value); 

}