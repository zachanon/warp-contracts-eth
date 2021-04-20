pragma solidity ^0.8.0;

interface IETHLock {

    function lockToken(/* uint256 amount, uint256 sidechain_id, uint256 token_id, uint256 to_address */) external returns(bool);
    function transferToken(/* uint256 amount, uint256 token_id, uint256 to_address */) external returns(bool);
}