pragma solidity ^0.4.18;

contract ERC223 {
    uint public totalSupply;
    function balanceOf(address who) constant returns (uint);
    function transfer(address to, uint value) returns (bool);
    function transfer(address to, uint value, bytes data) returns (bool);
    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}