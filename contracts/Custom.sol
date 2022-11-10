// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC1155LazyMint.sol";

contract Custom is ERC1155LazyMint {

    uint256[] supplies = [50,50];

    uint256[] minted = [0,0];

    uint256[] fees = [1 wei, 5 wei];

    mapping(uint256 => mapping(address => bool)) public claimed;


      constructor(
        string memory _name,
        string memory _symbol
    ) ERC1155LazyMint (_name, _symbol, msg.sender, 0){}

   

     function claimNFT(uint256 _tokenId, uint256 amount) external payable{
        require(
            !claimed[_tokenId][msg.sender],
            "You have already claimed this NFT."
        );    
        require(_tokenId <= supplies.length - 1, "NFT does not exist");
        uint256 index = _tokenId;

        require(msg.value >= amount * fees[index], "Insufficient Ether");
        require (minted[index] + amount <= supplies[index], "All the NFT have been minted");
        _mint(msg.sender, _tokenId, 1, "");
        
        minted[index] += amount;
        claimed[_tokenId][msg.sender] = true;
    }

    function withdraw(uint256 amount) public payable onlyOwner{
        require(address(this).balance >= amount, "No sufficient balance");
        payable(msg.sender).transfer(amount);
    }

    function getTotalNFTMinted(uint256 _tokenId) public view returns(uint256){
        return minted[_tokenId];
    }

    function getContractBal() public view returns(uint256 bal){
        return address(this).balance;
    }
}