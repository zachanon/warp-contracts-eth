pragma solidity ^0.8.0;

import "../../BaseOracle.sol";

contract xDAIOracle is BaseOracle {
        function triggerTransfer(/* uint256 amount, uint256 token_id, uint256 to_address */) internal returns(bool) {
            return true;
        }
}