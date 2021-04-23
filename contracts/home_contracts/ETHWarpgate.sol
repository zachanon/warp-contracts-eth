// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/token/ERC20/ERC20.sol";
import "../../interfaces/IETHWarpgate.sol";
import "../../interfaces/IOracle.sol";

contract ETHWarpgate is IETHWarpgate {

    IOracle oracle;

    //For ERC20: user account => token address => amount
    mapping(address => mapping(address => uint)) private tokensLocked;

    //For ETH: user account => amount in wei
    mapping(address => uint) private etherLocked;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
    }

    function lockEther() payable external returns(bool) {
        
        etherLocked[msg.sender] += msg.value;
        return true;
    }

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

    function claimEther(address payable _to, uint _amount) external returns(bool) {
        require(
            etherLocked[msg.sender] >= _amount,
            "Account does not have requested Ether"
        );

        etherLocked[msg.sender] -= _amount;
        _to.transfer(_amount);

        return true;
    }

    function claimTokens(address _token, uint _amount) override external returns(bool) {
        IERC20 token = IERC20(_token);

        require(
            tokensLocked[msg.sender][_token] >= _amount,
            "Account does not have requested tokens"
        );
        require(
            token.transfer(msg.sender, _amount),
            "Transfer failed"
        );

        tokensLocked[msg.sender][_token] -= _amount;
        return true;
    }

    function warpTokens(address _token, uint _amount, uint _chainid, uint _warp_address) override external returns(bool) {
        
        require(
            tokensLocked[msg.sender][_token] >= _amount,
            "Account does not have requested tokens locked"
        );

        tokensLocked[msg.sender][_token] -= _amount;
        emit WarpTokens(msg.sender, _token, _amount, _chainid, _warp_address);

        return true;
    }

    function dewarpTokens(address _token, uint _amount, uint _chainid, uint _warp_address) override external returns(bool) {
        
        require(
            oracle.verifyWarp(msg.sender, _token, _amount),
            "Oracle failed to verify"
        );

        IERC20 token = IERC20(_token);
        require(
            token.transfer(msg.sender, _amount),
            "Transfer failed"
        );

        tokensLocked[msg.sender][_token] += _amount;
        emit DewarpTokens(msg.sender, _token, _amount, _chainid, _warp_address);

        return true;
    }

    event WarpTokens(
        address indexed _user,
        address _token,
        uint _amount,
        uint _chainid,
        uint _warp_address
    );

    event DewarpTokens(
        address indexed _user,
        address _token,
        uint _amount,
        uint _chainid,
        uint _warp_address
    );
}