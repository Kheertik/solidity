// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Example {

    address owner;

    struct Counter {
        uint number;
        string desc;
    }

    Counter counter;
 
    modifier onlyOwner  {
        require(msg.sender == owner, "Only the owner can increment or decrement the counter");
        _;
    }

    constructor (uint inital_value, string memory description){
        owner = msg.sender;
        counter = Counter(inital_value, description);
    }


    function increment_counter() external onlyOwner {
        counter.number += 1;
    }

    function decrement_counter() external onlyOwner {
        counter.number -= 1;
    }

    function get_counter_number() external view returns (uint){
        return counter.number;
    }

    function get_counter_desc() external view returns ( string memory ){
        return counter.desc;
    }
}