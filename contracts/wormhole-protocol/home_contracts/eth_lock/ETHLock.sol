pragma solidity ^0.8.0;

import "../../../../interfaces/IETHLock.sol";

contract ETHLock is IETHLock {
    constructor() { }

    function lockToken(/* */) override external view returns(bool) {
        
        //TODO: Logic
        return true;
    }

    function transferToken(/*  */) override external view returns(bool) {

        //TODO: Logic
        return true;
    }

}