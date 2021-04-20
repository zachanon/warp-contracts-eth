pragma solidity ^0.8.0;

import "../../../../interfaces/IOracle.sol";

abstract contract BaseOracle is IOracle {
    function triggerUnlock(/* uint256 amount, uint256 token_id, uint256 to_address */) virtual internal returns(bool);
}