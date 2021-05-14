// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/token/ERC20/ERC20.sol";
import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/proxy/utils/Initializable.sol";
import "../interfaces/IOracle.sol";

/*
    Interface for users on the Ethereum chain.
        To WARP tokens:
        - The user first locks tokens with the WarpGate by calling lockTokens
        - The user then calls warpTokens with:
            - chainid of the chain to warp to
            - address on the foreign chain that can claim tokens
            - the token to warp and the amount

        To CLAIM tokens warped on a foreign chain:
        - The user must update the oracle with their claim
        - The user calls dewarpTokens with:
            - data of the tokens being claimed (chainid, amount, token address, foreign user address)
            - proof of the claim
        - The tokens will be assigned to the user but still locked in the WarpGate. To retrieve to the user address,
            the user must call claimTokens, which will transfer to the user specified address.
*/
contract WarpGate is Initializable {

    IOracle private _oracle;

    //For ERC20: user account => token address => amount
    mapping(address => mapping(address => uint)) private tokensLocked;

    function initialize(address oracle_) public initializer {
        _oracle = IOracle(oracle_);
    }

    /*
        User called function to lock tokens into the WarpGate.
        Must be called before tokens can be warped.
    */
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

    /*
        User called function to claim tokens locked in WarpGate.
    */
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

    /*
        User called function to warp tockens to a foreign chain. User must specify:
            - local token address and amount
            - foreign chainid
            - address that can claim tokens on the foreign chain

    */
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

    /*
        User called function to claim tokens warped from a foreign chain. User must first
        update the WarpGate oracle contract before calling. User must supply:
            - local address of the token and amount warped
            - foreign chainid and address that warped the tokens
            - proof of claim to submit to oracle

        Tokens will then be assigned to user in lock with the WarpGate.
    */
    function dewarpTokens(
        address _token,
        uint _amount,
        uint _chainid,
        uint _warp_address,
        uint256 root,
        uint256[] calldata proof
        ) external returns(bool)
    {
        
        require(
            _oracle.validate(root, proof),
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

    /*
        User called function to claim tokens warped from a foreign chain. User must first
        update the WarpGate oracle contract before calling. User must supply:
            - local address of the token and amount warped
            - foreign chainid and address that warped the tokens
            - proof of claim to submit to oracle

        Tokens will then be assigned to user in lock with the WarpGate.
    */
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
            _oracle.validate(leaf_parts, proof),
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

    //returns address of the validator oracle contract for this WarpGate
    function getWarpGateOracle() external view returns(address) {
        return address(_oracle);
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