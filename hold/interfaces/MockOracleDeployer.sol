pragma solidity ^0.8.0;

import "./MockConsensus.sol";
import "./Oracle.sol";


/**
* Deploys an Oracle with a mock consensus, for testing
*/
contract MockOracleDeployer
{
	event OracleDeployed( address oracle, address consensus );

	IOracle oracle;

	IOracleConsensus consensus;

	constructor()
	{
		consensus = new MockConsensus();

		oracle = new Oracle(consensus);

		emit OracleDeployed(oracle, consensus);
	}
}
