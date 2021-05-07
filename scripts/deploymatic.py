from brownie import MockOracle, ForeignGate, accounts

def main():
    deployment_account = accounts.load('deployment_matic')
    
    MockOracle.deploy({'from':deployment_account})
    ForeignGate.deploy(MockOracle[0].address, {'from':deployment_account})    