// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "./WarpToken.sol";

contract WarpedTokenManager {

    mapping(uint => address) deployedTokens;
    address deployer;

    constructor() {
        deployer = msg.sender;
    }

    function mintWarpedToken(address _user, uint _foreignAddress, uint _amount) external returns(bool) {

        require(
            msg.sender == deployer,
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

    function burnWarpedToken(address _user, uint _foreignAddress, uint _amount) external returns(bool) {

        require(
            msg.sender == deployer,
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
}