// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract LotteryContract {

    address public manager;
    address payable[] public participants;
    address payable public winner; 

    uint256 public constant entry_fee = 1 ether;

    constructor() payable{
        manager = msg.sender;
    }

    modifier onlyOwner() {
        require(manager == msg.sender, "You have to be the owner!");
        _;
    }

    receive() external payable {
        require(msg.value == entry_fee, "Must pay exactly 1 ether to participate!");
        participants.push(payable(msg.sender));
    }

    function pickWinner() public {
        require(msg.sender == manager);
        require(participants.length == 2);
        uint r = getRandom();
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable [] (0);
    }

    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function getRandom() public view returns (uint) {
        return(uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participants.length))));
    }
}
