// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IMetadataGenerator.sol";

contract Token is ERC721Royalty, Ownable {
    IMetadataGenerator public _metadataGenerator;

    constructor(
        string memory name,
        string memory symbol,
        address metadataGenerator
    ) ERC721(name, symbol) {
        _setDefaultRoyalty(msg.sender, 100);
        _metadataGenerator = IMetadataGenerator(metadataGenerator);
    }

    receive() external payable {}

    function safeMint(address to, uint256 tokenId) external payable {
        require(tokenId < 1000, "Only 1000 tokens");
        require(msg.value == 1 ether, "Minting costs 1 Eth");
        _safeMint(to, tokenId);
    }

    function setRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    function setMetadataGenerator(address metadataGenerator) public onlyOwner {
        _metadataGenerator = IMetadataGenerator(metadataGenerator);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return _metadataGenerator.generateMetadata(tokenId);
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        (bool success,) = owner().call{value: amount}("");
        require(success, "Failed to send");
    }
}
