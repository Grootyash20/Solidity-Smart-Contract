// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract withdrawal{
    address payable manager;
    mapping(address=>uint) richestperson;
    address payable richest;
    uint richest_value; 

    constructor() payable{
        richest = payable(msg.sender);
        richest_value = msg.value;
    }

    function sendEther() public payable{
        require(msg.value>richest_value,"You are not the richest guy outta here");
        richest = payable(msg.sender);
        richest_value = msg.value;
        richestperson[msg.sender] = msg.value;
    }

    function withdraw() public payable{
        require(richest==msg.sender,"What do you think you trynna do?");
        uint amount = richestperson[msg.sender];
        require(amount>0,"No funds to withdraw");
        payable((msg.sender)).transfer(amount);
        richestperson[msg.sender] = 0;
        richest_value = 0;
    }

}
