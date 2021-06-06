/*
 * Deployment script for LOGIKFlaminHot.sol
 *
 * Created: June 3, 2021
 * Author: Jack Kasbeer
 */

const { ethers } = require("hardhat");

async function main() {
	const Breffis = await ethers.getContractFactory("Breffis");

	// Start deployment
	const breffis = await Breffis.deploy();
	console.log("Breffis contract deployed to address:", breffis.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
