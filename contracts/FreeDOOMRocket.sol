// SPDX-License-Identifier: MIT
/*
 * LOGIK: FreeDOOM Rocket
 *
 * Created: June 2, 2021
 * Author: Jack Kasbeer
 * Description: ERC721 w/ a dynamic URI based on the date that links to 
 * 				different versions of an animation by LOGIK
 * Mainnet Address:
 * Rinkeby Address: 0xCf3d210B28521420712c00CCEF743bD69e3Ca530
 */

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FreeDOOMRocket is ERC721, Ownable {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	uint constant NUM_ASSETS = 3;
	uint private _creationTime;
	string[NUM_ASSETS] _assetHashes = ["QmWogPztGXiW6tbCcEfk2m819n1QPrQK7EVnxgZdPVRUPD", 
							  		   "QmNawKGNQxweTEzKADMoqXbAsyCDYR3KWbsCstrazKbwFC",
							  		   "QmWogPztGXiW6tbCcEfk2m819n1QPrQK7EVnxgZdPVRUPD"];
	// 0: "Air this bitch out"
	// 1: 
	// ...


	// (!) NOTE: we need to remove this and turn it into an initializer for upgrade-ability
	constructor() ERC721("LOGIK: FreeDOOM Rocket", "") {
		_creationTime = block.timestamp;
	}


	// Override the tokenURI function to return a different URI depending
	// on how many days its been since creation
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
	{
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
		string memory baseURI = _baseURI(); //we'll need this to complete the URI

		// Get current time & determine how many days have gone by since creation
		uint todayTime = block.timestamp;
		uint256 daysPassed = uint256((todayTime - _creationTime) / 60 / 60 / 24);

		// Every day, rotate in the next URI
		uint idx = daysPassed % NUM_ASSETS;

		assert(0 <= idx && idx < _assetHashes.length);//proof by inspection, but im alpha af

		return string(abi.encodePacked(baseURI, _assetHashes[idx]));
	}


	// Override ERC721's _baseURI
	function _baseURI() internal view virtual override returns (string memory) 
	{
		return "https://gateway.pinata.cloud/ipfs/";
	}


	// Mint a single LOGIKFreeDOOMRocket
	function mintFreeDOOMRocket(address recipient) public onlyOwner returns (uint256)
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
