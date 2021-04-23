// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;


interface IOracle
{
	function validate( uint256 root, uint256[] calldata proof ) external view returns (bool);

	/**
	* Convenience method, called provides the leaf components to be hashed before calling validate
	*/
	function validate( uint256[] memory leaf_parts, uint256[] calldata proof ) external view returns (bool);
}

