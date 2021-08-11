
const { ethers } = require("hardhat");

async function main() {
	const BLMTest = await ethers.getContractFactory("BLMTest");

	// Start deployment
	const blm = await BLMTest.deploy();
	console.log("Contract deployed to address:", blm.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
