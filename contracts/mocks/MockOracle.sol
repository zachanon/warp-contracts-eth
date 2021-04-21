pragma solidity ^0.8.0;

import "../../interfaces/IOracle.sol";

contract MockOracle is IOracle {

	function validate( uint256 fact, uint256[] memory proof ) override external view returns (bool) {
        return true;
    }
    	
    function verifyWarp(address _user, address _token, uint _amount) override external returns(bool){
        return true;
    }
    
}