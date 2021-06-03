// SPDX-License-Identifier: MIT
/*
 * LOGIK x BLM x NiftyGateway: Rocket Launcher
 *
 * Created: June 2, 2021
 * Author: Jack Kasbeer
 * Description: ERC721 w/ a dynamic URI based on the date
 * Address:
 */

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BLMTest is ERC721, Ownable {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	uint constant NUM_DAYS_IN_CYCLE = 10;

	uint private _creationTime;

	// if there are 10 days in the cycle, 
	// we want 5 different .mov's (repeated twice in the array)
	string[2] _assetHashes = ["QmQr5GPfbboVMkntaBYYSMoSzR29bZMGPNefon4GiCEZzm", "QmNawKGNQxweTEzKADMoqXbAsyCDYR3KWbsCstrazKbwFC"];


	// (!) NOTE: we need to remove this and turn it into an initializer for upgrade-ability
	constructor() ERC721("BLMTest", "BLM0") {
		_creationTime = block.timestamp;
	}


	// Override the tokenURI function to return a different URI depending
	// on how many days its been since creation
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
	{
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

		uint todayTime = block.timestamp;
		// uint8 hourNow = uint8((todayTime / 60 / 60) % 24);
		uint256 daysPassed = uint256((todayTime - _creationTime) / 60 / 60 / 24);
		uint idx = daysPassed % NUM_DAYS_IN_CYCLE;

		assert(0 <= idx && idx < _assetHashes.length); //unnecessary really but..

		return _assetHashes[idx];
	}


	// Override ERC721's _baseURI
	function _baseURI() internal view virtual override returns (string memory) 
	{
		return "https://gateway.pinata.cloud/ipfs/";
	}


	// Mint a single LOGIKRocketLauncher
	function mintRocketLauncher(address recipient) public onlyOwner returns (uint256)
	{	
		_tokenIds.increment(); //for future collectibles

		uint256 newCollectibleId = _tokenIds.current();
		_safeMint(recipient, newCollectibleId);
		//_setTokenURI(newCollectibleId, uri);

		return newCollectibleId;
	}


	// Small function for testing some logic w/ time
	function daysSinceCreation() public view returns (uint256) 
	{
		return uint256((block.timestamp - _creationTime) / 60 / 60 / 24);
	}
}
