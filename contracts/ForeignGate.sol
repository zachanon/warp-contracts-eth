// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "./WarpedTokenManager.sol";
import "../interfaces/IValidator.sol";

/*
    Contract for users to interface with on foreign chains. Provides warp and dewarp functions.
*/
contract ForeignGate {

    IValidator private _validator;
    WarpedTokenManager private _tokenManager;

    constructor(address validator_) {
        _validator = IValidator(validator_);
        _tokenManager = new WarpedTokenManager();
    }

    /*
        Called when user wishes to transport their tokens off this chain.
        Requires user to specify which chain they would like to warp on to, and the address of the
        account on the foreign chain that can claim the warped tokens. Then burns tokens from user's
        address and emits a WarpTokens event.
    */
    function warpTokens(uint token_, uint amount_, uint chainId_, uint warpAddress_) external returns(bool) {

        require(
            tokenManager.burnWarpedToken(msg.sender, token_, amount_),
            "Failed to burn tokens"
        );

        emit WarpTokens(
            msg.sender,
            token_,
            amount_, 
            chainId_, 
            warpAddress_);
        return true;
    }

    /*
        Called when user wishes to claim tokens warped from another chain. User must submit data for the validator to verify against.
        If claim is successful, mints the claimed WarpTokens to user's wallet and emits a DewarpTokens event.
    */
    function dewarpTokens(
        address token_,
        uint amount_,
        uint chainId_,
        uint warpAddress_
        ) external returns(bool)
    {
        require(
            _validator.validate(
                msg.sender,
                token_,
                amount_,
                chainId_,
                warpAddress_),
            "Failed to validate"
        );

        require(
            tokenManager.mintWarpedToken(msg.sender, token_, amount_),
            "Failed to mint tokens"
        );

        emit DewarpTokens(
            msg.sender,
            token_,
            amount_,
            chainId_,
            warpAddress_);
        
        return true;
    }

    event WarpTokens(
        address indexed user,
        address token,
        uint amount,
        uint chainId,
        uint warpAddress
    );

    event DewarpTokens(
        address indexed user,
        address token,
        uint amount,
        uint chainId,
        uint warpAddress
    );
}
