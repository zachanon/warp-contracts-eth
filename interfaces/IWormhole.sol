// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

interface IWormhole {
    function burnToken(/* amount, tokenid, address */) external returns(bool);
}