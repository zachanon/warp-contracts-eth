// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

interface IOracle {

	function validate(
		address user_,
		address token_,
		uint256 amount_,
		uint256 chainId_,
		uint256 warpAddress_
		) external returns(bool);
}