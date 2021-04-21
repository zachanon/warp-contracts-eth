pragma solidity ^0.8.0;


interface IOracle
{
	//Not sure whether to use keyword memory, calldata or storage https://docs.soliditylang.org/en/v0.8.3/types.html#index-14
	function validate( uint256 fact, uint256[] memory proof ) external returns (bool);

	function verifyWarp(address _user, address _token, uint amount) external returns(bool);
}

