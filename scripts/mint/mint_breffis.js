/*
 * Mint script for Breffis.sol
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

const breffisContract=require("../../artifacts/contracts/Breffis.sol/Breffis.json");
const breffisAddress = "";//rinkeby
const breffisNFT = new web3.eth.Contract(breffisContract.abi, breffisAddress);

async function mintBreffis() {
	const nonce = await web3.eth.getTransactionCount(STAGING_PUBLIC_KEY, 'latest');

	// the transaction
	const tx = {
		'from': STAGING_PUBLIC_KEY,
		'to': breffisAddress,
		'nonce': nonce,
		'gas': 500000,
		'data': breffisNFT.methods.mintBreffis(STAGING_PUBLIC_KEY).encodeABI()
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

mintBreffis();
