from brownie import accounts, MyToken, ETHWarpgate, MockOracle

def test_lock_and_claim():
    MockOracle.deploy({'from':accounts[-1]})
    ETHWarpgate.deploy(MockOracle[0].address, {'from':accounts[-1]})
    
    initial_balance = accounts[1].balance()

    ETHWarpgate[0].lockEther({'from':accounts[0],'value':10000})


    ETHWarpgate[0].claimEther(accounts[1].address, 1000, {'from':accounts[0]})
    assert(accounts[1].balance() == 1000 + initial_balance), "Ether claim did not pay properly"

    try:
        ETHWarpgate[0].claimEther(accounts[1].address, 100000, {'from':accounts[1]})
        assert (accounts[1].balance() == 1000 + initial_balance), "Ether claim pays indiscriminately"

    except:
        pass


    ETHWarpgate[0].claimEther(accounts[1].address, 9000, {'from':accounts[0]})
    assert(accounts[1].balance() == 10000 + initial_balance), "Ether claim fails to pay all locked"