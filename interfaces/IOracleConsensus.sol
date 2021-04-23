// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;


interface IOracleConsensus
{
	//Not sure whether to use keywork memory, calldata or storage https://docs.soliditylang.org/en/v0.8.3/types.html#index-14
	function validate( uint256 root, uint256[] memory state ) external view returns (bool);
}
