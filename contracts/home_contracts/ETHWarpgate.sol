pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/token/ERC20/ERC20.sol";
import "../../interfaces/IETHWarpgate.sol";

contract ETHWarpgate is IETHWarpgate {

    // account with locked tokens => token address => amount
    mapping(address => mapping(address => uint)) public tokensLocked;


    function lockTokens(address _token, uint _amount) override external returns(bool) {
        IERC20 token = IERC20(_token);
        require(
            token.allowance(msg.sender, address(this)) >= _amount,
            "Token allowance too low"
        );
        require(
            token.transferFrom(msg.sender, address(this), _amount),
            "Transfer failed"
        );

        tokensLocked[msg.sender][_token] += _amount;

        return true;
    }

    function claimTokens(address _token, uint _amount) override external returns(bool) {

        require(
            tokensLocked[msg.sender][_token] >= _amount,
            "Account does not have requested tokens"
        );
        return true;
    }
}