// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ChainsEnumerableMapLib} from "../src/utils/ChainsEnumerableMapLib.sol";
import {Chains, ChainIdContract, ChainIdAbi, Abi, chainContract, chainAbi, blockRangeFull} from "../src/Triggers.sol";

contract ChainsEnumerableMapLibTest is Test {
    using ChainsEnumerableMapLib for ChainsEnumerableMapLib.ChainsToChainIdContractMap;
    using ChainsEnumerableMapLib for ChainsEnumerableMapLib.ChainsToChainIdAbiMap;

    ChainsEnumerableMapLib.ChainsToChainIdContractMap contractMap;
    ChainsEnumerableMapLib.ChainsToChainIdAbiMap abiMap;

    address constant TEST_CONTRACT = address(0x1234567890123456789012345678901234567890);
    address constant TEST_CONTRACT_2 = address(0x9876543210987654321098765432109876543210);

    function test_contractMap_set_and_get() public {
        ChainIdContract memory ethContract = chainContract(Chains.Ethereum, TEST_CONTRACT);

        bool wasAdded = contractMap.set(Chains.Ethereum, ethContract);
        assertTrue(wasAdded);

        assertTrue(contractMap.contains(Chains.Ethereum));
        assertEq(contractMap.length(), 1);

        ChainIdContract memory retrieved = contractMap.get(Chains.Ethereum);
        assertEq(retrieved.chainId, 1);
        assertEq(retrieved.contractAddress, TEST_CONTRACT);
    }

    function test_contractMap_overwrite_existing() public {
        ChainIdContract memory ethContract1 = chainContract(Chains.Ethereum, TEST_CONTRACT);
        ChainIdContract memory ethContract2 = chainContract(Chains.Ethereum, TEST_CONTRACT_2);

        bool wasAdded1 = contractMap.set(Chains.Ethereum, ethContract1);
        assertTrue(wasAdded1);

        bool wasAdded2 = contractMap.set(Chains.Ethereum, ethContract2);
        assertFalse(wasAdded2); // Should return false when updating existing key

        assertEq(contractMap.length(), 1); // Length should remain 1

        ChainIdContract memory retrieved = contractMap.get(Chains.Ethereum);
        assertEq(retrieved.contractAddress, TEST_CONTRACT_2); // Should have updated address
    }

    function test_contractMap_multiple_chains() public {
        ChainIdContract memory ethContract = chainContract(Chains.Ethereum, TEST_CONTRACT);
        ChainIdContract memory baseContract = chainContract(Chains.Base, TEST_CONTRACT_2);

        contractMap.set(Chains.Ethereum, ethContract);
        contractMap.set(Chains.Base, baseContract);

        assertEq(contractMap.length(), 2);
        assertTrue(contractMap.contains(Chains.Ethereum));
        assertTrue(contractMap.contains(Chains.Base));

        assertEq(contractMap.get(Chains.Ethereum).chainId, 1);
        assertEq(contractMap.get(Chains.Base).chainId, 8453);
    }

    function test_contractMap_remove() public {
        ChainIdContract memory ethContract = chainContract(Chains.Ethereum, TEST_CONTRACT);

        contractMap.set(Chains.Ethereum, ethContract);
        assertTrue(contractMap.contains(Chains.Ethereum));

        bool wasRemoved = contractMap.remove(Chains.Ethereum);
        assertTrue(wasRemoved);

        assertFalse(contractMap.contains(Chains.Ethereum));
        assertEq(contractMap.length(), 0);

        bool wasRemovedAgain = contractMap.remove(Chains.Ethereum);
        assertFalse(wasRemovedAgain); // Should return false when removing non-existent key
    }

    function test_contractMap_tryGet() public {
        ChainIdContract memory ethContract = chainContract(Chains.Ethereum, TEST_CONTRACT);
        contractMap.set(Chains.Ethereum, ethContract);

        (bool exists, ChainIdContract memory retrieved) = contractMap.tryGet(Chains.Ethereum);
        assertTrue(exists);
        assertEq(retrieved.contractAddress, TEST_CONTRACT);

        (bool existsEmpty,) = contractMap.tryGet(Chains.Base);
        assertFalse(existsEmpty);
    }

    function test_contractMap_getAtIndex() public {
        ChainIdContract memory ethContract = chainContract(Chains.Ethereum, TEST_CONTRACT);
        ChainIdContract memory baseContract = chainContract(Chains.Base, TEST_CONTRACT_2);

        contractMap.set(Chains.Ethereum, ethContract);
        contractMap.set(Chains.Base, baseContract);

        (Chains chain0, ChainIdContract memory contract0) = contractMap.getAtIndex(0);
        (Chains chain1, ChainIdContract memory contract1) = contractMap.getAtIndex(1);

        // Order depends on internal implementation, just verify both are present
        assertTrue(
            (chain0 == Chains.Ethereum && contract0.contractAddress == TEST_CONTRACT)
                || (chain0 == Chains.Base && contract0.contractAddress == TEST_CONTRACT_2)
        );
        assertTrue(
            (chain1 == Chains.Ethereum && contract1.contractAddress == TEST_CONTRACT)
                || (chain1 == Chains.Base && contract1.contractAddress == TEST_CONTRACT_2)
        );
    }

    function test_contractMap_keys() public {
        contractMap.set(Chains.Ethereum, chainContract(Chains.Ethereum, TEST_CONTRACT));
        contractMap.set(Chains.Base, chainContract(Chains.Base, TEST_CONTRACT_2));
        contractMap.set(Chains.Arbitrum, chainContract(Chains.Arbitrum, TEST_CONTRACT));

        Chains[] memory allKeys = contractMap.keys();
        assertEq(allKeys.length, 3);

        // Verify all expected chains are present
        bool hasEthereum = false;
        bool hasBase = false;
        bool hasArbitrum = false;

        for (uint256 i = 0; i < allKeys.length; i++) {
            if (allKeys[i] == Chains.Ethereum) hasEthereum = true;
            if (allKeys[i] == Chains.Base) hasBase = true;
            if (allKeys[i] == Chains.Arbitrum) hasArbitrum = true;
        }

        assertTrue(hasEthereum);
        assertTrue(hasBase);
        assertTrue(hasArbitrum);
    }

    function test_contractMap_update() public {
        ChainIdContract memory ethContract = chainContract(Chains.Ethereum, TEST_CONTRACT);

        // Add with update
        bool wasAdded = contractMap.update(Chains.Ethereum, ethContract, true, 10);
        assertTrue(wasAdded);
        assertTrue(contractMap.contains(Chains.Ethereum));

        // Remove with update
        bool wasRemoved = contractMap.update(Chains.Ethereum, ethContract, false, 10);
        assertTrue(wasRemoved);
        assertFalse(contractMap.contains(Chains.Ethereum));
    }

    function test_abiMap_basic_operations() public {
        Abi memory testAbi = Abi({name: "TestProtocol"});
        ChainIdAbi memory ethAbi = chainAbi(Chains.Ethereum, testAbi);

        bool wasAdded = abiMap.set(Chains.Ethereum, ethAbi);
        assertTrue(wasAdded);

        assertTrue(abiMap.contains(Chains.Ethereum));
        assertEq(abiMap.length(), 1);

        ChainIdAbi memory retrieved = abiMap.get(Chains.Ethereum);
        assertEq(retrieved.chainId, 1);
        assertEq(retrieved.abi.name, "TestProtocol");
    }

    function test_abiMap_multiple_protocols() public {
        Abi memory uniswapAbi = Abi({name: "Uniswap"});
        Abi memory aaveAbi = Abi({name: "Aave"});

        abiMap.set(Chains.Ethereum, chainAbi(Chains.Ethereum, uniswapAbi));
        abiMap.set(Chains.Base, chainAbi(Chains.Base, aaveAbi));

        assertEq(abiMap.length(), 2);
        assertEq(abiMap.get(Chains.Ethereum).abi.name, "Uniswap");
        assertEq(abiMap.get(Chains.Base).abi.name, "Aave");
    }
}
