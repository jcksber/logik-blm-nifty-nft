// SPDX-License-Identifier: MIT
/*
 * LOGIK: Breffis
 *
 * Created: June 2, 2021
 * Author: Jack Kasbeer
 * Description: ERC721 w/ a static URI that links to a simple animation by LOGIK
 * Address:
 */

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Breffis is ERC721, Ownable {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	uint constant NUM_HOURS_IN_CYCLE = 6;
	uint constant NUM_ASSETS = 4;
	uint private _creationTime;
	uint private _lastHashIdx;
	string[NUM_ASSETS] _assetHashes = ["QmWogPztGXiW6tbCcEfk2m819n1QPrQK7EVnxgZdPVRUPD", 
							  		   "QmNawKGNQxweTEzKADMoqXbAsyCDYR3KWbsCstrazKbwFC",
							  		   "QmWogPztGXiW6tbCcEfk2m819n1QPrQK7EVnxgZdPVRUPD",
							  		   "QmNawKGNQxweTEzKADMoqXbAsyCDYR3KWbsCstrazKbwFC"];
	// 0: Sunrise
	// 1: Day
	// 2: Sunset
	// 3: Night


	// (!) NOTE: we need to remove this and turn it into an initializer for upgrade-ability
	constructor() ERC721("LOGIK: Breffis", "") {
		_creationTime = block.timestamp;
		_lastHashIdx = _assetHashes.length - 1;//so we start with 0 in tokenURI
	}


	// Override the tokenURI function for our needs
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
	{
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
		
		string memory baseURI = _baseURI(); //we'll need this to complete the URL

		// Get current time & determine how many hours have gone by since creation
		uint todayTime = block.timestamp;
		uint256 hoursPassed = uint256((todayTime - _creationTime) / 60 / 60);
		uint idx = _lastHashIdx;

		// If a multiple of 6 hours have passed, rotate in the next URI
		if (hoursPassed % NUM_HOURS_IN_CYCLE == 0) { //hour 6, 12, 18, 24
			idx = _lastHashIdx < (_assetHashes.length - 1)
				? _lastHashIdx + 1 
				: 0;
		} //else, continue using the current URI

		assert(0 <= idx && idx < _assetHashes.length);//we assert for the culture, not the proof

		return string(abi.encodePacked(baseURI, _assetHashes[idx]));
	}


	// Override _baseURI
	function _baseURI() internal view virtual override returns (string memory) 
	{
		return "https://gateway.pinata.cloud/ipfs/";
	}


	// Mint a single LOGIKFlaminHot
	function mintBreffis(address recipient) public onlyOwner returns (uint256)
	{
		_tokenIds.increment(); //for future collectibles

		uint256 newBreffisId = _tokenIds.current();
		_safeMint(recipient, newBreffisId);

		return newBreffisId;
	}

	// (!) ARE WE MISSING ANYTHING UNRELATED TO UPGRADES????
}
