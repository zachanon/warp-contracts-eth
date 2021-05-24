// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/token/ERC20/ERC20.sol";


/*
    Contract representing an ERC20 token located on Ethereum. Minted to users that successfully
    claim warped tokens through the ForeignGate contract.
*/
contract WarpToken is ERC20 {

    address private _deployer;


    constructor (string memory name_, string memory symbol_) ERC20(name_, symbol_) {
        _deployer = msg.sender;
    }

    /*
     * Function called only by WarpedTokenManager. Mints tokens to user claiming from the ForeignGate
     */
    function mint(address to_, uint amount_) external returns(bool) {

        require(
            msg.sender == _deployer,
            "Only the deployer can call this function"
        );

        _mint(to_, amount_);
        return true;
    }

    /*
     * Function called only by WarpedTokenManager. Burns tokens from user calling warpTokens function from ForeignGate
     */
    function burn(address from_, uint amount_) external returns(bool) {

        require(
            msg.sender == _deployer,
            "Only the deployer can call this function"
        );

        _burn(from_, amount_);
        return true;
    }
}