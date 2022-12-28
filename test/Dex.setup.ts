import { expect } from "chai";
import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

describe("Dex Exploit", function () {
  var deployer: SignerWithAddress, attacker: SignerWithAddress;
  const INITIAL_MINT_TOKEN = ethers.utils.parseEther("10000000");
  const INITIAL_DEX_BALANCE = ethers.utils.parseEther("100");
  const INITIAL_ATTACKER_BALANCE = ethers.utils.parseEther("10");
  before(async function () {
    [deployer, attacker] = await ethers.getSigners();

    this.dex = await (
      await ethers.getContractFactory("Dex", deployer)
    ).deploy();
    this.token1 = await (
      await ethers.getContractFactory("SwappableToken", deployer)
    ).deploy(this.dex.address, "token1", "TK1", INITIAL_MINT_TOKEN);
    this.token2 = await (
      await ethers.getContractFactory("SwappableToken", deployer)
    ).deploy(this.dex.address, "token2", "TK2", INITIAL_MINT_TOKEN);

    // Setting the tokens for the dex contract
    await this.dex.setTokens(this.token1.address, this.token2.address);

    // Adding liquidity to the dex according to Ethernaut question
    await this.dex.approve(this.dex.address, INITIAL_DEX_BALANCE);
    await this.dex.addLiquidity(this.token1.address, INITIAL_DEX_BALANCE);
    await this.dex.addLiquidity(this.token2.address, INITIAL_DEX_BALANCE);

    // Sending liquidity to the attacker according to Ethernaut question
    await this.token1.transfer(attacker.address, INITIAL_ATTACKER_BALANCE);
    await this.token2.transfer(attacker.address, INITIAL_ATTACKER_BALANCE);
  });
  it("Should have tokens addresses set correctly", async function checkDexTokenAddresses() {
    expect(await this.dex.token1()).to.be.eq(this.token1.address);
    expect(await this.dex.token2()).to.be.eq(this.token2.address);
  });

  it("Should have attacker balances set correctly", async function checkAttackerBalance() {
    expect(await this.token1.balanceOf(attacker.address)).to.eq(
      INITIAL_ATTACKER_BALANCE
    );
    expect(await this.token2.balanceOf(attacker.address)).to.eq(
      INITIAL_ATTACKER_BALANCE
    );
  });

  it("Should have Dex balance set correctly", async function checkDexBalance() {
    expect(await this.token1.balanceOf(this.dex.address)).to.eq(
      INITIAL_DEX_BALANCE
    );
    expect(await this.token2.balanceOf(this.dex.address)).to.eq(
      INITIAL_DEX_BALANCE
    );
  });
  it("Should Exploit", async function exploit() {
    /**
     * Your Exploit code here!
     */
  });
});
