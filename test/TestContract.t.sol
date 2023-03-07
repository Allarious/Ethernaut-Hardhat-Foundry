// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/TestContract.sol";

contract TestContractTest is Test {
    struct Obj {
        uint256 num;
    }

    TestContract t;
    mapping (address => Obj) map;


    function setUp() public {
    }

    function testMapping() public {
        map[address(10)].num = 20;
        console.log(map[address(10)].num);
        setMap(address(10));
        console.log(map[address(10)].num);
    }
    
    function setMap(address _address) internal returns(Obj memory obj){
        map[_address] = obj;
    }
}
