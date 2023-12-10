import { ethers } from "hardhat";

async function main() {

  const dolaCommunicate = await ethers.deployContract("DolaCommmunicate", ["0xcfFC3a8893cEf48F4B6F9F7f0b7627Cbd9301852"]);

  await dolaCommunicate.waitForDeployment();

  console.log("DolaCommunicate deployed to:", dolaCommunicate);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
