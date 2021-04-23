// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "../../interfaces/IOracleConsensus.sol";


contract MockConsensus is IOracleConsensus
{
	constructor() {
		
	}

	function validate( uint256 root, uint256[] memory state ) override external view returns (bool)
	{
		return true;
	}
}
