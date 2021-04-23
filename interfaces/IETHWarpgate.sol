// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

interface IETHWarpgate {

    function lockTokens(address _token, uint _amount) external returns(bool);

    function claimTokens(address _token, uint _amount) external returns(bool);
    
    function warpTokens(address _token, uint _amount, uint _chainid, uint _warp_address) external returns(bool);

    function dewarpTokens(address _token, uint _amount, uint _chainid, uint _warp_address) external returns(bool);
}