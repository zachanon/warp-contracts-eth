// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "./chainlink/dev/ChainlinkClient.sol";
import "../interfaces/IOracle.sol";

contract GateOracle is ChainlinkClient, IOracle {

    address private _oracle;
    bytes32 private _jobId;
    uint256 private _fee;

    mapping(uint256 => bool) _validationSuccess;

    constructor(
        address oracle_,
        bytes32 jobId_,
        uint256 fee_)
    {
        setPublicChainlinkToken();
        _oracle = oracle_;
        _jobId = jobId_;
        _fee = fee_;
     }

    function requestValidation(
         address user_,
		address token_,
		uint256 amount_,
		uint256 chainId_,
		uint256 warpAddress_
    ) external
    {
        Chainlink.Request memory request = buildChainlinkRequest(_jobId, address(this), this.fulfill.selector);

        request.add("get", "https://PLACEHOLDER");
        request.add("path", "PATH.TO.VALIDATION.BOOLEAN");
        return sendChainlinkRequestTo(_oracle, _request, _fee);
    }

    function fulfill() external {}

    function validate(
		address user_,
		address token_,
		uint256 amount_,
		uint256 chainId_,
		uint256 warpAddress_) override external returns(bool)
        {
            //PLACEHOLDER
            return true;
        }
}