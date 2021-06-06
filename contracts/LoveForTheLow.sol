// SPDX-License-Identifier: MIT
/*
 * LOGIK: Love for the Low
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

contract LoveForTheLow is ERC721, Ownable {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	// (!) NOTE: we need to remove this and turn it into an initializer for upgrade-ability
	constructor() ERC721("LOGIK: Love for the Low", "") {}


	// Override the tokenURI function for our needs
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
	{
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
		
		string memory baseURI = _baseURI();
		string memory assetHash = ""; // (!) UPDATE ONCE READY

		return string(abi.encodePacked(baseURI, assetHash));
	}


	// Override _baseURI
	function _baseURI() internal view virtual override returns (string memory) 
	{
		return "https://gateway.pinata.cloud/ipfs/";
	}


	// Mint a single LOGIKFlaminHot
	function mintRoses(address recipient) public onlyOwner returns (uint256)
	{
		_tokenIds.increment(); //for future collectibles

		uint256 newLoveId = _tokenIds.current();
		_safeMint(recipient, newLoveId);

		return newLoveId;
	}

	// (!) ARE WE MISSING ANYTHING UNRELATED TO UPGRADES????
}
