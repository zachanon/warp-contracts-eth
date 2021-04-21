import sys
from brownie import accounts, MyToken, ETHWarpgate, MockOracle

def test_lock_and_claim():
    MyToken.deploy("mytoken","mysymbol",{'from':accounts[0]})
    MockOracle.deploy({'from':accounts[-1]})
    ETHWarpgate.deploy(MockOracle[0].address, {'from':accounts[-1]})
    initial_balance = 100000000000000000000
    num_lock = 1000

    MyToken[0].approve(ETHWarpgate[0], num_lock, {'from':accounts[0]})
    ETHWarpgate[0].lockTokens(MyToken[0].address, num_lock, {'from':accounts[0]})

    userbalance_preclaim = MyToken[0].balanceOf(accounts[0])
    contractbalance_preclaim = MyToken[0].balanceOf(ETHWarpgate[0])
    assert(contractbalance_preclaim == num_lock), "Preclaim: Contract balance invalid"
    assert(userbalance_preclaim == initial_balance - num_lock), "Preclaim: User balance invalid"

    ETHWarpgate[0].claimTokens(MyToken[0].address, num_lock, {'from':accounts[0]})

    userbalance_postclaim = MyToken[0].balanceOf(accounts[0])
    contractbalance_postclaim = MyToken[0].balanceOf(ETHWarpgate[0])
    assert(contractbalance_postclaim == contractbalance_preclaim - num_lock), "Postclaim: Contract balance invalid"
    assert(userbalance_postclaim == userbalance_preclaim + num_lock), "Postclaim: Contract balance invalid"

    #assert(False), "testing"