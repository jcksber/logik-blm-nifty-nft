/*
 * Deployment script for LOGIKRoses.sol
 *
 * Created: June 3, 2021
 * Author: Jack Kasbeer
 */

const { ethers } = require("hardhat");

async function main() {
	const Roses = await ethers.getContractFactory("LOGIKRoses");

	// Start deployment
	const roses = await Roses.deploy();
	console.log("LOGIKRoses contract deployed to address:", flaminHot.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
