/*
 * Deployment script for LoveForTheLow.sol
 *
 * Created: June 3, 2021
 * Author: Jack Kasbeer
 */

const { ethers } = require("hardhat");

async function main() {
	const LoveForTheLow = await ethers.getContractFactory("LoveForTheLow");

	// Start deployment
	const love = await LoveForTheLow.deploy();
	console.log("LoveForTheLow contract deployed to address:", love.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
