// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/token/ERC20/presents/ERC20PresetMinterPauser.sol";

//Running TODO:
// fix coonstructor call, decide on name and symbol data
// which of _mint/mint and _burn/burn
contract WarpedTokenMinterBurner {

    mapping(uint => address) deployedTokens;
    address deployer;

    constructor() {
        deployer = msg.sender;
    }

    function mintWarpedToken(address _user, uint _foriegnAddress, uint _amount) external returns(bool) {

        require(
            msg.sender == deployer,
            "User does not have permisson to mint"
        );

        if(deployedTokens[_foriegnAddress] != 0) {
            deployedTokens[_foriegnAddress].mint(_user, _amount);
            return true;
        }
        else {
            ERC20PresetMinterPauser newToken = new ERC20PresetMinterPauser("name","symbol");
            deployedTokens[_foreignAddress] = address(newToken);
            newToken._mint(_user, _amount);
            return true;
        }

        return false;
    }

    function burnWarpedToken(address _user, uint _foreignAddress, uint _amount) external returns(bool) {

        require(
            msg.sender == deployer,
            "User does not have permisson to mint"
        );

        deployedTokens[_foreignAddress]._burn(_user, _amount);
        return true;
    }
}