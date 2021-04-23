// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "../../interfaces/IOracle.sol";


contract MockOracle is IOracle
{
	function validate( uint256 fact, uint256[] memory proof )
		external view override
		returns (bool)
	{
        return true;
    }

    function validate( uint256[] memory leaf_parts, uint256[] calldata proof )
		external view override
		returns (bool)
	{
		return true;
	}
}