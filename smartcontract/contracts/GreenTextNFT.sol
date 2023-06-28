// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/* For test */
//import "hardhat/console.sol";

contract GreenTextNFT is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    
    Counters.Counter private _tokenIdCounter;
    address payable private _adminAccount;
    uint256 private _mintFee;
    string private _baseURL;
    address payable private _servAccount;
    int32 private _servFee;

    constructor(address adminAccount) ERC721("GreenText", "GreenText") {
        _adminAccount = payable(adminAccount);
        _mintFee = 3 * 10 ** 15;
        _baseURL = "https://95.217.33.149/green-text-nft/";
        _servFee = 0;
        _servAccount = payable(0);
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseURL = baseURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);
        return string(abi.encodePacked(_baseURL, tokenId.toString(), ".png"));
    }

    function setAdminAccount(address adminAccount) external onlyOwner {
        _adminAccount = payable(adminAccount);
    }

    function setServAccount(address servAccount, int32 servFee) external onlyOwner {
        require(servFee >= 0 && servFee <= 100, "Fee is invalid.");
        _servAccount = payable(servAccount);
        _servFee = servFee;
    }

    function mint() public payable {
        address payable sender = payable(msg.sender);
        require(msg.value >= _mintFee, "Insufficient Fee");

        bool sent;
        if (_servFee > 0 && _servAccount != payable(0)) {
            uint256 value = msg.value * uint256(int256(100 - _servFee)) / 100;
            sent = _adminAccount.send(value);
            sent = _servAccount.send(msg.value - value);
        }
        else
            sent = _adminAccount.send(msg.value);
        
        if (sent)
        {
            //if (msg.value > _mintFee)
            //    sender.transfer(msg.value - _mintFee);
            
            uint256 tokenId = _tokenIdCounter.current();
            //console.log("Minting token:", tokenId);
            _tokenIdCounter.increment();
            _safeMint(sender, tokenId);
        }
    }

    /*function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override(ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }*/
}
