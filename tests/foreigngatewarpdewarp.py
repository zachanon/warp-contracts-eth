import sys
from brownie import accounts, MockOracle, ForeignGate

def test_warp_and_dewarp():
    MockOracle.deploy({'from':accounts[-1]})
    ForeignGate.deploy(MockOracle[0].address, {'from':accounts[-1]})

    #warp
    ForeignGate.warpTokens(111, 1000, 0, 0, {'from':accounts[0]})