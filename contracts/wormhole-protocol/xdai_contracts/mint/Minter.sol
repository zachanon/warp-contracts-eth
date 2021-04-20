pragma solidity ^0.8.0;

import "../../../../interfaces/IMinter.sol";

contract Minter is IMinter {

    constructor() { }

    function mintToken(/* uint256 amount, uint256 tokenId, uint256 toAddress */) override external returns(bool) {

        return true;
    }

}