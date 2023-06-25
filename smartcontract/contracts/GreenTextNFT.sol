// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/* For test */
//import "hardhat/console.sol";

contract GreenTextNFT is ERC721, ERC721Enumerable {
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIdCounter;

    //address private _nativeToken;
    address payable private _adminAccount;
    uint256 private _mintFee;

    constructor(/*address nativeToken, */address adminAccount) ERC721("GreenText", "GreenText") {
        //_nativeToken = nativeToken;
        _adminAccount = payable(adminAccount);
        _mintFee = 3 * 10 ** 15;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://localhost/green-text-nft/";
    }

    function mint() public payable {
        address payable sender = payable(msg.sender);
        //console.log("Sender's Balance:", sender.balance);
        //console.log("Sented Fee:", msg.value);
        //console.log("Required Fee:", _mintFee);
        require(_adminAccount != sender, "Not user");
        require(msg.value >= _mintFee, "Insufficient Fee");

        //uint256 balance = IERC20(_nativeToken).balanceOf(to);
        //require(balance >= _mintFee, "Insufficent fee");
        //if (IERC20(_nativeToken).transferFrom(to, _adminAccount, _mintFee))

        //console.log("Transfering %s from %s to %s...", _mintFee, sender, _adminAccount);
        if (_adminAccount.send(_mintFee))
        {
            if (msg.value > _mintFee)
                sender.transfer(msg.value - _mintFee);
            
            uint256 tokenId = _tokenIdCounter.current();
            //console.log("Minting token:", tokenId);
            _tokenIdCounter.increment();
            _safeMint(sender, tokenId);
        }
        //else
            //console.log("Failed to transfer native currency");
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
