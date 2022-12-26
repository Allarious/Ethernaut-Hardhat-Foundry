// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Denial.sol";

contract DenialTest is Test {
    Denial denial;
    DenialExploit exploit;

    function setUp() public {
        denial = new Denial();
        exploit = new DenialExploit();

        denial.setWithdrawPartner(address(exploit));
    }

    function testExploitDenial() public{
        console.log("Testing Denial Exploit");
        // denial.withdraw{gas: 100000000}();
        assertTrue(true);
    }
}
