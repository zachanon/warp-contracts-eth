pragma solidity ^0.8.0;

import "../../../../interfaces/IWormhole.sol";

contract xDAIWormhole is IWormhole {
    constructor() { }

    function burnToken(/* amount, tokenid, address */) override external returns(bool) {
        return true;
    }
}