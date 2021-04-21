import sys
from brownie import accounts, MyToken, ETHWarpgate

def main():
    MyToken.deploy("mytoken","mysymbol",{'from':accounts[0]})
    ETHWarpgate.deploy({'from':accounts[-1]})

    MyToken[0].approve(ETHWarpgate[0], 1000, {'from':accounts[0]})
    ETHWarpgate[0].lockTokens(MyToken[0].address, 100, {'from':accounts[0]})

    ETHWarpgate[0].claimTokens(MyToken[0].address, 100, {'from':accounts[0]})
    ETHWarpgate[0].claimTokens(MyToken[0].address, 1000, {'from':accounts[0]})