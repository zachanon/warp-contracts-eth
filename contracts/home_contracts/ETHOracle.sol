// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "../../interfaces/IOracle.sol";

contract ETHOracle is IOracle {

    //For ERC20: user account => token address => amount
    mapping(address => mapping(address => uint)) private tokensWarped;

	function validate(address _token, uint _amount) override external returns (bool){
        
        //Fetch data from outside?

        tokensWarped[msg.sender][_token] += _amount;
        
        return true;
    }

	function verifyWarp(address _user, address _token, uint _amount) override external returns(bool) {
        
        require(
            tokensWarped[_user][_token] >= _amount,
            "Not enough tokens have been confirmed warped"
        );
        return true;
    }
}