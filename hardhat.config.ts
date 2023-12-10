// import config before anything else
import { config as dotEnvConfig } from "dotenv";
dotEnvConfig();
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const PRIVATE_KEY = process.env.PRIVATE_KEY || "";


const config: HardhatUserConfig = {
  solidity: "0.8.19",

  etherscan: {
    apiKey: {
     "baseGoerli": "PLACEHOLDER_STRING"
    }
  },

  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
      gas: 12000000,
      blockGasLimit: 0x1fffffffffffff,
    },
    mantleTestnet: {
      url: `https://rpc.testnet.mantle.xyz	`,
      accounts: [PRIVATE_KEY],
    },
    baseTestnet: {
      url: `https://goerli.base.org	`,
      accounts: [PRIVATE_KEY],
    }
  },
};

export default config;
