// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "./chainlink/dev/ChainlinkClient.sol";
import "../interfaces/IOracle.sol";

contract Oracle is ChainlinkClient, IOracle {

    constructor() { }

    function validate(uint256 root, uint256[] calldata proof) override external returns(bool) {
        return true;
    }
}