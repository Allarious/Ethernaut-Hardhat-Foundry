// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/TestContract.sol";

contract TestContractTest is Test {
    TestContract t;

    function setUp() public {
    }

    function testAddressZero() public {
        (bool success, bytes memory returndata) = address(0).staticcall(
            abi.encodeWithSignature("getData()")
        );
        console.logBytes(returndata);
        console.log(returndata.length);
    }
}
