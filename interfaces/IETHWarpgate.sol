pragma solidity ^0.8.0;

interface IETHWarpgate {

    function lockTokens(address _token, uint _amount) external returns(bool);
    function claimTokens(address _token, uint _amount) external returns(bool);
}