// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/token/ERC20/ERC20.sol";
import "../interfaces/IOracle.sol";


contract WarpGate
{
    IOracle oracle;

    //For ERC20: user account => token address => amount
    mapping(address => mapping(address => uint)) private tokensLocked;

    constructor(address _oracle)
    {
        oracle = IOracle(_oracle);
    }

    function lockTokens(address _token, uint _amount)
        external returns(bool)
    {
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

    function claimTokens(address _token, uint _amount)
        external returns(bool)
    {
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

    function warpTokens(address _token, uint _amount, uint _chainid, uint _warp_address)
        external returns(bool)
    {
        
        require(
            tokensLocked[msg.sender][_token] >= _amount,
            "Account does not have requested tokens locked"
        );

        tokensLocked[msg.sender][_token] -= _amount;
        emit WarpTokens(msg.sender, _token, _amount, _chainid, _warp_address);

        return true;
    }

    
    //TODO: what gets passed here, and which oracle validate do we call?
    //overload function for both oracle methods?
    function dewarpTokens(
        address _token,
        uint _amount,
        uint _chainid,
        uint _warp_address,
        uint256 root,
        uint256[] calldata proof
        )
        external returns(bool)
    {
        
        require(
            oracle.validate(root, proof),
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

    function dewarpTokens(
        address _token,
        uint _amount,
        uint _chainid,
        uint _warp_address,
        uint256[] memory leaf_parts,
        uint256[] calldata proof
        )
        external returns(bool)
    {
        
        require(
            oracle.validate(leaf_parts, proof),
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