// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "./WarpToken.sol";

//Contract callable only to the deployer. Used to mint and burn wrapped tokens corresponding to the address of the token on the ETH chain.
contract WarpedTokenManager {

    address private _deployer;
    mapping(uint => address) private deployedTokens;

    constructor() {
        _deployer = msg.sender;
    }

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

    function getMintedTokenAddress(uint _foreignAddress) external returns(address) {

        require(
            deployedTokens[_foreignAddress] != address(0),
            "Token not deployed"
        );

        return deployedTokens[_foreignAddress];
    }
}