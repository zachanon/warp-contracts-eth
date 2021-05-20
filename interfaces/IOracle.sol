// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

interface IOracle {

	function validate(uint256 root, uint256[] calldata proof) external returns(bool);
}