// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/token/ERC20/ERC20.sol";
import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/proxy/utils/Initializable.sol";
import "../interfaces/IValidator.sol";

/*
    Interface for users on the Ethereum chain.
        To WARP tokens:
        - The user first locks tokens with the WarpGate by calling lockTokens
        - The user then calls warpTokens with:
            - chainid of the chain to warp to
            - address on the foreign chain that can claim tokens
            - the token to warp and the amount

        To CLAIM tokens warped on a foreign chain:
        - The user must update the validator with their claim
        - The user calls dewarpTokens with:
            - data of the tokens being claimed (chainid, amount, token address, foreign user address)
            - proof of the claim
        - The tokens will be assigned to the user but still locked in the WarpGate. To retrieve to the user address,
            the user must call claimTokens, which will transfer to the user specified address.
*/
contract WarpGate  {

    IValidator private _validator;

    //For ERC20: user account => token address => amount
    mapping(address => mapping(address => uint)) private _tokensLocked;

    constructor(address validator_) {
        _validator = IValidator(validator_);
    }

    /*
        User called function to lock tokens into the WarpGate.
        Must be called before tokens can be warped.
    */
    function lockTokens(address token_, uint amount_)
        external returns(bool)
    {
        IERC20 token = IERC20(token_);
        
        require(
            token.allowance(msg.sender, address(this)) >= amount_,
            "Token allowance too low"
        );
        require(
            token.transferFrom(msg.sender, address(this), amount_),
            "Transfer failed"
        );

        tokensLocked[msg.sender][token_] += amount_;

        return true;
    }

    /*
        User called function to claim tokens locked in WarpGate.
    */
    function claimTokens(address token_, uint amount_)
        external returns(bool)
    {
        IERC20 token = IERC20(token_);

        require(
            tokensLocked[msg.sender][token_] >= amount_,
            "Account does not have requested tokens"
        );
        require(
            token.transfer(msg.sender, amount_),
            "Transfer failed"
        );

        tokensLocked[msg.sender][token_] -= amount_;
        return true;
    }

    /*
        User called function to warp tockens to a foreign chain. User must specify:
            - local token address and amount
            - foreign chainid
            - address that can claim tokens on the foreign chain

    */
    function warpTokens(
        address token_,
        uint amount_,
        uint chainId_, 
        uint warpAddress_
        )
        external returns(bool)
    {
        
        require(
            tokensLocked[msg.sender][token_] >= amount_,
            "Account does not have requested tokens locked"
        );

        tokensLocked[msg.sender][token_] -= amount_;

        emit WarpTokens(
            msg.sender,
            token_,
            amount_,
            chainId_,
            warpAddress_);

        return true;
    }

    /*
        User called function to claim tokens warped from a foreign chain. User must first
        update the WarpGate validator contract before calling. User must supply:
            - local address of the token and amount warped
            - foreign chainid and address that warped the tokens
            - proof of claim to submit to validator

        Tokens will then be assigned to user in lock with the WarpGate.
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
            "validator failed to verify"
        );

        IERC20 token = IERC20(token_);
        require(
            token.transfer(msg.sender, amount_),
            "Transfer failed"
        );

        tokensLocked[msg.sender][token_] += amount_;
       
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