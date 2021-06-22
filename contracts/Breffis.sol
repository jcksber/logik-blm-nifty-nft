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

	uint constant DAY_TIME = 6; //day asset @ 0600 UTC	
	uint constant NIGHT_TIME = 18;//night asset @ 1800 UTC
	uint constant NUM_ASSETS = 2;

	uint private _creationTime;
	string[NUM_ASSETS] _assetHashes = ["QmSPLV7SsSuy3EUNtJzVtfJqB2TjyXFWg18kYzd7RWFDmX", 
							  		   "QmWogPztGXiW6tbCcEfk2m819n1QPrQK7EVnxgZdPVRUPD"];
	// 0: Day
	// 1: Night

	// (!) NOTE: we need to remove this and turn it into an initializer for upgrade-ability
	constructor() ERC721("LOGIK: Breffis", "") {
		_creationTime = block.timestamp;
	}


	// Override the tokenURI function for our needs
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
	{
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
		string memory baseURI = _baseURI(); //we'll need this to complete the URI

		// Get current hour of the day
		uint8 hour = uint8((block.timestamp / 60 / 60) % 24);

		uint idx = 0;
		// If it's after 6am UTC and before 6pm UTC, it's daytime
		if (DAY_TIME <= hour && hour < NIGHT_TIME) {
			idx = 0; //Day time
		} else {
			idx = 1; //Night time
		}

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
