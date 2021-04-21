pragma solidity ^0.8.0;

import "../../../interfaces/IOracle.sol";

contract HomeOracle is IOracle {
        function validate( uint256 fact, uint256[] memory proof ) override external view returns(bool) {
            return true;
        }
}