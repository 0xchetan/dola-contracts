import { ethers } from "hardhat";

async function main() {

  const mockUSDC = await ethers.deployContract("MockUSDC", [1000000000 * 1e6]);

  await mockUSDC.waitForDeployment();

  console.log("DolaCommunicate deployed to:", mockUSDC);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
