pragma solidity ^0.8.0;

interface IWormhole {
    function burnToken(/* amount, tokenid, address */) external returns(bool);
}