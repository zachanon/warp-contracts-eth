from brownie import accounts, MyToken, ETHWarpgate, MockOracle

def main():
    MockOracle.deploy({'from':accounts[-1]})
    ETHWarpgate.deploy(MockOracle[0].address, {'from':accounts[-1]})
