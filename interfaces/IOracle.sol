// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;


interface IOracle
{
	//Not sure whether to use keyword memory, calldata or storage https://docs.soliditylang.org/en/v0.8.3/types.html#index-14
	function validate( uint256 root, uint256[] memory state ) external view returns (bool);

	function verifyWarp(address _user, address _token, uint amount) external returns(bool);
}

