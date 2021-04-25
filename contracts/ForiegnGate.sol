// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "../interfaces/IForeignGate.sol";
import "./WarpedTokenMinter.sol";

//TODO: warp/dewarp logic, oracle logic
contract ForeignGate is IForeignGate {

    IOracle oracle;
    WarpedTokenMinterBurner tokenManager;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
        tokenManager = new WarpedTokenMinterBurner();
    }

    function warpTokens(address _token, uint _amount, uint _chainid, uint _warp_address) override external returns(bool) {

        //token burning logic
        require();

        emit WarpTokens(msg.sender, _token, _amount, _chainid, _warp_address);
        return true;
    }

    function dewarpTokens(address _token, uint _amount, uint _chainid, uint _warp_address) override external returns(bool) {

        //oracle validation
        require();

        //mint
        require();

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