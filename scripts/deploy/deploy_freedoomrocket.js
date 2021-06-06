/*
 * Deployment script for FreeDOOMRocket.sol
 *
 * Created: June 3, 2021
 * Author: Jack Kasbeer
 */

const { ethers } = require("hardhat");

async function main() {
	const Rocket = await ethers.getContractFactory("FreeDOOMRocket");

	// Start deployment
	const rocket = await Rocket.deploy();
	console.log("FreeDOOMRocket contract deployed to address:", rocket.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
