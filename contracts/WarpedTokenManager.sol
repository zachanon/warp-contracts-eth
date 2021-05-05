// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "./WarpToken.sol";

/*
    Contract to manage and deploy all WarpToken contracts for the ForeignGate.
    Functions only callable by the ForeignGate contract.
*/
contract WarpedTokenManager {

    address private _deployer;
    mapping(uint => address) private deployedTokens;

    constructor() {
        _deployer = msg.sender;
    }

    /*
        Called when user successfully claims warped tokens through ForeignGate dewarpTokens function
        First checks if token contract found at _foreignAddress on ETH has been deployed before. If not,
        deploys a new WarpToken contract before minting to user. Otherwise mints to user.
    */
    function mintWarpedToken(address _user, uint _foreignAddress, uint _amount) external returns(bool) {

        require(
            msg.sender == _deployer,
            "User does not have permisson to mint"
        );

        if(deployedTokens[_foreignAddress] != address(0)) {
            WarpToken token = WarpToken(deployedTokens[_foreignAddress]);
            token.mint(_user, _amount);
            return true;
        }
        else {
            WarpToken token = new WarpToken("WrappedWarpToken","WARP");
            deployedTokens[_foreignAddress] = address(token);
            token.mint(_user, _amount);
            return true;
        }

        return false;
    }

    /*
        Called when user submits tokens to ForeignGate warpTokens function.
        Calls WarpToken burn function to remove tokens from user's address.
    */
    function burnWarpedToken(address _user, uint _foreignAddress, uint _amount) external returns(bool) {

        require(
            msg.sender == _deployer,
            "User does not have permisson to burn"
        );
        require(
            deployedTokens[_foreignAddress] != address(0),
            "Token does not exist"
        );

        WarpToken token = WarpToken(deployedTokens[_foreignAddress]);
        token.burn(_user, _amount);
        
        return true;
    }

    /*
     * Returns the contract address of the WarpToken representing the token found at _foreignAddress on ETH chain
     */
    function getMintedTokenAddress(uint _foreignAddress) external returns(address) {

        require(
            deployedTokens[_foreignAddress] != address(0),
            "Token not deployed"
        );

        return deployedTokens[_foreignAddress];
    }
}