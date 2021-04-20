pragma solidity ^0.8.0;

import "../../interfaces/IOracleConsensus.sol";


contract MockConsensus is IOracleConsensus
{
	constructor() public {}

	function validate( uint256 root, uint256[] memory state )
		override public pure returns (bool)
	{
		return true;
	}
}
