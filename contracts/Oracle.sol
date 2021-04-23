// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "../interfaces/IOracle.sol";
import "../interfaces/IOracleConsensus.sol";


contract Oracle is IOracle
{
	IOracleConsensus consensus;

	mapping(uint256 => bool) roots;

	constructor( IOracleConsensus _consensus )
	{
		consensus = _consensus;
	}

	function validate( uint256 fact, uint256[] calldata proof )
		external view override
		returns (bool)
	{
		// Merkle root must have previously been comitted to by Oracle
		require( roots[proof[0]] == true );

		// TODO: verify merkle path authenticator path for `fact`

		return true;
	}

	function validate( uint256[] memory leaf_parts, uint256[] calldata proof )
		external view override
		returns (bool)
	{
		return this.validate(uint256(keccak256(abi.encodePacked(leaf_parts))), proof);
	}

	/**
	* Provides a new merkle root which can be verified against
	*/
	function update( uint256 root, uint256[] calldata state )
		external
	{
		// Ensure root doesn't exist
		require( false == roots[root] );

		// Ensure consensus has attested to the validity of this root
		// Consensus may ensure other conditions, that's not a concern of the Oracle though
		require( consensus.validate(root, state) == true );

		roots[root] =  true;
	}
}
