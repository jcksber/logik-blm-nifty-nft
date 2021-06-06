/*
 * Mint script for FreeDOOMRocket.sol
 *
 * Created: June 3, 2021
 * Author: Jack Kasbeer
 */

require('dotenv').config();
const STAGING_ALCHEMY_API_URL = process.env.STAGING_ALCHEMY_API_URL;
const STAGING_PRIVATE_KEY = process.env.STAGING_PRIVATE_KEY;
const STAGING_PUBLIC_KEY = process.env.STAGING_PUBLIC_KEY;

const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(STAGING_ALCHEMY_API_URL);

const rbContract=require("../../artifacts/contracts/FreeDOOMRocket.sol/FreeDOOMRocket.json");
const rbAddress = "0xCf3d210B28521420712c00CCEF743bD69e3Ca530";//rinkeby
const rbNFT = new web3.eth.Contract(rbContract.abi, rbAddress);

async function mintFreeDOOMRocket() {
	const nonce = await web3.eth.getTransactionCount(STAGING_PUBLIC_KEY, 'latest');

	// the transaction
	const tx = {
		'from': STAGING_PUBLIC_KEY,
		'to': rbAddress,
		'nonce': nonce,
		'gas': 500000,
		'data': rbNFT.methods.mintFreeDOOMRocket(STAGING_PUBLIC_KEY).encodeABI()
	};

	const signPromise = web3.eth.accounts.signTransaction(tx, STAGING_PRIVATE_KEY);
	signPromise.then((signedTx) => {

		web3.eth.sendSignedTransaction(signedTx.rawTransaction, function(err, hash) {
			if (!err) {
				console.log("The hash of your transaction is: ", hash, "\nCheck Alchemy's Mempool to view the status of your transaction!");
			} else {
				console.log("Something went wrong when submitting your transaction:", err);
			}
		});
	}).catch((err) => {
		console.log("Promise failed:", err);
	});
}

mintFreeDOOMRocket();

// print days since creation 
// async function days() {
// 	const rbContract=require("../../artifacts/contracts/LOGIKRocketBitch.sol/LOGIKRocketBitch.json");
// 	const rbAddress = "0xC4F633d498C01845CF5367F064ca8863F02573B8";//rinkeby
// 	const rbNFT = new web3.eth.Contract(rbContract.abi, rbAddress);
// 	const day = rbNFT.methods.daysSinceCreation().call();
// 	return day;
// }

// days()
// 	.then((num) => {
// 		console.log(num);
// 		process.exit(0);
// 	})
// 	.catch(error => {
// 		console.log(error);
// 		process.exit(1);
// 	});

