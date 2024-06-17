// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0; 

contract Practice{

    address admin;
    constructor(){
        admin = msg.sender;
    }
    function returnmsg() public view returns(address){
        return msg.sender;
    }

    // mapping(uint => mapping(uint => bool)) data;

    // function insert(uint key1,uint key2,bool val) public{
    //     data[key1][key2] = val;
    // }
    // function returnelem(uint key1, uint key2) public view returns(bool){
    //     return data[key1][key2];
    // }



    // mapping(uint=>uint[4]) public data;
    // function insert(uint key,uint[4] memory arr) public{
    //     data[key]=arr;
    // }
    // function returnele(uint key,uint value) public view returns(uint){
    //     return data[key][value];
    // }


    // struct Employee{
    //     uint id;
    //     string name;
    // }
    // mapping(uint => Employee) public data;
    // function insert(uint key, Employee memory e) public{ 
    //     data[key] = e;
    // }
    // function returnmap(uint key)public view returns(Employee memory){
    //     return data[key]; 
    // }


    // mapping(uint=>string) public data;
    // function insert(uint key, string memory value) public{
    //     data[key]=value;
    // }
    

    // struct Employee{
    //     bytes6 name;
    //     uint id;
    // }
    // Employee[4] e;
    // function insert(uint index,bytes6 _name,uint _id) public{
    //     e[index] = Employee(_name,_id);
    // }
    // function returnstruct(uint index) public view returns(bytes6){
    //     return e[index].name;
    // }

}
