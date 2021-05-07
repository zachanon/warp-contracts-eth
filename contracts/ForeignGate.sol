// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "./WarpedTokenManager.sol";
import "../interfaces/IOracle.sol";

/*
    Contract for users to interface with on foreign chains. Provides warp and dewarp functions.
*/
contract ForeignGate {

    IOracle private oracle;
    WarpedTokenManager private tokenManager;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
        tokenManager = new WarpedTokenManager();
    }

    /*
        Called when user wishes to transport their tokens off this chain.
        Requires user to specify which chain they would like to warp on to, and the address of the
        account on the foreign chain that can claim the warped tokens. Then burns tokens from user's
        address and emits a WarpTokens event.
    */
    function warpTokens(uint _token, uint _amount, uint _chainid, uint _warp_address) external returns(bool) {

        require(
            tokenManager.burnWarpedToken(msg.sender, _token, _amount),
            "Failed to burn tokens"
        );

        emit WarpTokens(msg.sender, _token, _amount, _chainid, _warp_address);
        return true;
    }

    /*
        Called when user wishes to claim tokens warped from another chain. User must submit data for the oracle to verify against.
        If claim is successful, mints the claimed WarpTokens to user's wallet and emits a DewarpTokens event.
    */
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

    /*
        Called when user wishes to claim tokens warped from another chain. User must submit data for the oracle to verify against.
        If claim is successful, mints the claimed WarpTokens to user's wallet and emits a DewarpTokens event.
    */
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

    //returns the address of the oracle verifier contract for ForeignGate
    function getForeignGateOracle() external view returns(address) {
        return address(oracle);
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
