/*
 * Deployment script for LOGIKFlaminHot.sol
 *
 * Created: June 3, 2021
 * Author: Jack Kasbeer
 */

const { ethers } = require("hardhat");

async function main() {
	const FlaminHot = await ethers.getContractFactory("LOGIKFlaminHot");

	// Start deployment
	const flaminHot = await FlaminHot.deploy();
	console.log("LOGIKFlaminHot contract deployed to address:", flaminHot.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
