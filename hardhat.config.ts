import { HardhatUserConfig } from "hardhat/config"
import "@nomicfoundation/hardhat-toolbox"

const config: HardhatUserConfig = {
    solidity: "0.8.17",
    paths: { sources: "./src/contracts" },
}

export default config
