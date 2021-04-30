// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "./WarpedTokenManager.sol";
import "../interfaces/IOracle.sol";


//TODO: warp/dewarp logic, oracle logic
contract ForeignGate {

    IOracle oracle;
    WarpedTokenManager tokenManager;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
        tokenManager = new WarpedTokenManager();
    }

    function warpTokens(uint _token, uint _amount, uint _chainid, uint _warp_address) external returns(bool) {

        require(
            tokenManager.burnWarpedToken(msg.sender, _token, _amount),
            "Failed to burn tokens"
        );

        emit WarpTokens(msg.sender, _token, _amount, _chainid, _warp_address);
        return true;
    }

    function dewarpTokens(uint _token, uint _amount, uint _chainid, uint _warp_address, uint256 root, uint256[] calldata proof ) external returns(bool) {

        require(
            oracle.validate(root, proof),
            "Oracle validate failed"
        );

        require(
            tokenManager.mintWarpedToken(msg.sender, _token, _amount),
            "Failed to mint tokens"
        );

        emit DewarpTokens(msg.sender, _token, _amount, _chainid, _warp_address);
        return true;
    }

    function dewarpTokens(uint _token, uint _amount, uint _chainid, uint _warp_address, uint256[] memory leaf_parts, uint256[] calldata proof ) external returns(bool) {

        require(
            oracle.validate(leaf_parts, proof),
            "Oracle validate failed"
        );

        require(
            tokenManager.mintWarpedToken(msg.sender, _token, _amount),
            "Failed to mint tokens"
        );

        emit DewarpTokens(msg.sender, _token, _amount, _chainid, _warp_address);
        return true;
    }

    event WarpTokens(
        address indexed _user,
        uint _token,
        uint _amount,
        uint _chainid,
        uint _warp_address
    );

    event DewarpTokens(
        address indexed _user,
        uint _token,
        uint _amount,
        uint _chainid,
        uint _warp_address
    );
}
