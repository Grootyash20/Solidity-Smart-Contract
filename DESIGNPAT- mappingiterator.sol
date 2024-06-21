// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract test{ 
    mapping(address=>uint) map;  
    address[] public arr; 
    function create() public{  
        //any code
        arr.push(msg.sender);//this is important as mapping is non iterable, so you can push it into an array.
    }
}
