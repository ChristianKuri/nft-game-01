// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract Token is ERC721, Ownable {
    struct Pet {
        uint8 damage; // 0 - 255
        uint8 magic; // 0 - 255
        uint256 lastMeal;
        uint256 endurance;
    }

    uint256 nextId = 0;

    mapping(uint256 => Pet) private _tokenDetails;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    modifier isAlive(uint256 tokenid) {
        require(_tokenDetails[tokenid].lastMeal + _tokenDetails[tokenid].endurance > block.timestamp);
        _;
    }

    function mint(
        uint8 damage,
        uint8 magic,
        uint8 endurance
    ) public onlyOwner {
        _tokenDetails[nextId] = Pet(damage, magic, block.timestamp, endurance);
        _safeMint(msg.sender, nextId);
        nextId++;
    }

    function feed(uint256 tokenid) public isAlive(tokenid) {
        Pet storage pet = _tokenDetails[tokenid];
        pet.lastMeal = block.timestamp;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override isAlive(tokenId) {}
}
