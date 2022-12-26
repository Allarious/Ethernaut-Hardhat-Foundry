// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Shop.sol";

contract ShopTest is Test{
    Shop shop;
    ShopExploit exploit;
    function setUp() public {
        shop = new Shop();
        exploit = new ShopExploit(address(shop));
    }

    function testExploitShop() public {
        console.log("Testing Shop Exploit");
        exploit.buyLower();
        console.log(shop.price());
    }
}