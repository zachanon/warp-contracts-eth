from brownie import WarpGate, MockOracle, MockERC20, accounts

def main():
    deployment_account = accounts.load('deployment_account')
    
    MockERC20.deploy("MockToken", "MOCK", {'from':deployment_account})
    MockOracle.deploy({'from':deployment_account})
    WarpGate.deploy(MockOracle[0].address, {'from':deployment_account})