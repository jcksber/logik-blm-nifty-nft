// SPDX-License-Identifier: MIT
/*
 * LOGIK x BLM x NiftyGateway: Rocket Bitch
 *
 * Created: June 2, 2021
 * Author: Jack Kasbeer
 * Description: ERC721 w/ a dynamic URI based on the date that links to 
 * 				different versions of an animation by LOGIK
 * Address:
 */

// NOTE: 5 ASSETS, 10 DAY CYCLE

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LOGIKRocketBitch is ERC721, Ownable {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	uint constant NUM_DAYS_IN_CYCLE = 10;
	uint private _creationTime;
	uint private _lastHashIdx;
	string[5] _assetHashes = ["QmWogPztGXiW6tbCcEfk2m819n1QPrQK7EVnxgZdPVRUPD", 
							  "QmNawKGNQxweTEzKADMoqXbAsyCDYR3KWbsCstrazKbwFC",
							  "QmNawKGNQxweTEzKADMoqXbAsyCDYR3KWbsCstrazKbwFC",
							  "QmNawKGNQxweTEzKADMoqXbAsyCDYR3KWbsCstrazKbwFC",
							  "QmNawKGNQxweTEzKADMoqXbAsyCDYR3KWbsCstrazKbwFC"];
	// 0: "Air this bitch out"
	// 1: 
	// ...


	// (!) NOTE: we need to remove this and turn it into an initializer for upgrade-ability
	constructor() ERC721("LOGIK x BLM: Rocket Bitch", "LGKRB") {
		_creationTime = block.timestamp;
		_lastHashIdx = 4; //so we start with 0 in tokenURI
	}


	// Override the tokenURI function to return a different URI depending
	// on how many days its been since creation
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
	{
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

		string memory baseURI = _baseURI();
		// Get current time & determine how many days have gone by since creation
		uint todayTime = block.timestamp;
		uint256 daysPassed = uint256((todayTime - _creationTime) / 60 / 60 / 24);
		uint idx = _lastHashIdx;

		// If a multiple of 10 days have passed, rotate in the next URI
		if (daysPassed % NUM_DAYS_IN_CYCLE == 0) {
			// Day 0, 10, 20, 30, ...
			idx = _lastHashIdx < (_assetHashes.length - 1)
				? _lastHashIdx + 1 
				: 0;
		} //else, continue using the current URI

		assert(0 <= idx && idx < _assetHashes.length); //probably proof by inspection but...YOLO

		return string(abi.encodePacked(baseURI, _assetHashes[idx]));
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

		uint256 newRocketId = _tokenIds.current();
		_safeMint(recipient, newRocketId);

		return newRocketId;
	}


	// Small function for testing some logic w/ time
	function daysSinceCreation() public view returns (uint256) 
	{
		return uint256((block.timestamp - _creationTime) / 60 / 60 / 24);
	}
}
