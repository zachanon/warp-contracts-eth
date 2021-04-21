pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/token/ERC20/ERC20.sol";
import "../../interfaces/IETHWarpgate.sol";
import "../../interfaces/IOracle.sol";

contract ETHWarpgate is IETHWarpgate {

    IOracle oracle;

    //public keyword, only getters, or must change visibility?
    // user account => token address => amount
    mapping(address => mapping(address => uint)) public tokensLocked;

    constructor(address _oracle) public {
        oracle = IOracle(_oracle);
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

    function unwarpTokens(address _token, uint _amount, uint _chainid, uint _warp_address) override external returns(bool) {
        
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

        return true;
    }

    event WarpTokens(
        address indexed _user,
        address _token,
        uint _amount,
        uint _chainid,
        uint _warp_address
    );
}