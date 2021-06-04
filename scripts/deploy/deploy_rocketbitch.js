/*
 * Deployment script for LOGIKRocketBitch.sol
 *
 * Created: June 3, 2021
 * Author: Jack Kasbeer
 */

const { ethers } = require("hardhat");

async function main() {
	const RocketBitch = await ethers.getContractFactory("LOGIKRocketBitch");

	// Start deployment
	const rocketBitch = await RocketBitch.deploy();
	console.log("LOGIKRocketBitch contract deployed to address:", rocketBitch.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
