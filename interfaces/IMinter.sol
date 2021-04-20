pragma solidity ^0.8.0;

interface IMinter {
    function mintToken(/* uint256 amount, uint256 tokenId, uint256 toAddress */) external returns(bool);
}