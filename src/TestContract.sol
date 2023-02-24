// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import "forge-std/console.sol";

contract TestContract {
    address public add =  0x199D5ED7F45F4eE35960cF22EAde2076e95B253F;
    constructor () {}

    function convert(address _address) public returns(string memory){
        return Strings.toHexString(_address);
    }
}
