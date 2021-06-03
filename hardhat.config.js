/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");

const { STAGING_ALCHEMY_API_URL,
		STAGING_PRIVATE_KEY, 
		STAGING_PUBLIC_KEY,
		MAINNET_ALCHEMY_API_URL,
		MAINNET_PRIVATE_KEY,
		MAINNET_PUBLIC_KEY } = process.env;

module.exports = {
	solidity: "0.8.0",
	defaultNetwork: "rinkeby",
	networks: {
		hardhat: {},
		rinkeby: {
			url: STAGING_ALCHEMY_API_URL,
			accounts: [`0x${STAGING_PRIVATE_KEY}`]
		}
	}
};
