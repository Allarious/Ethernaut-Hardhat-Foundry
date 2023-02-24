// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/TestContract.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract TestContractTest is Test {
    TestContract t;

    function setUp() public {
        t = new TestContract();
    }

    function testEncodePacked() public {
        address _address = address(1);
        console.log(address(1));
        console.logBytes(abi.encodePacked("10", _address));
        assertEq(abi.encodePacked("", _address), abi.encodePacked("", ERC20(_address)));
    }
}
