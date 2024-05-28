// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract factory{
    car[] public arr;
    function createobj() public{
    car car1 = new car();
    arr.push(car1);
    }

    function returncarobjs() public view returns(car[] memory){
        return arr;
    }
}
contract car{

}
