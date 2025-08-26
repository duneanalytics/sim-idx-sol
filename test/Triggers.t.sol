// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {
    BlockRangeKind,
    BlockRange,
    BlockRangeLib,
    blockRangeFull,
    blockRangeFrom,
    blockRangeInclusive,
    Chains,
    ChainIdAbi,
    ChainIdGlobal,
    ChainIdContract,
    chainToChainId,
    ChainWithRange,
    ChainsLib,
    chainContract,
    chainAbi,
    chainGlobal,
    Abi,
    BaseTriggers,
    Trigger,
    RawTrigger,
    TriggerType,
    RawTriggerType
} from "../src/Triggers.sol";

contract TriggersTest is Test {
    function setUp() public {}

    function test_blockRangeFrom() public pure {
        BlockRange memory range = blockRangeFrom(100);
        assertEq(uint256(range.kind), uint256(BlockRangeKind.RangeFrom));
        assertEq(range.startBlockInclusive, 100);
        assertEq(range.endBlockInclusive, 0);
    }

    function test_blockRangeInclusive() public pure {
        BlockRange memory range = blockRangeInclusive(100, 200);
        assertEq(uint256(range.kind), uint256(BlockRangeKind.RangeInclusive));
        assertEq(range.startBlockInclusive, 100);
        assertEq(range.endBlockInclusive, 200);
    }

    function test_blockRangeFull() public pure {
        BlockRange memory range = blockRangeFull();
        assertEq(uint256(range.kind), uint256(BlockRangeKind.RangeFull));
        assertEq(range.startBlockInclusive, 0);
        assertEq(range.endBlockInclusive, 0);
    }

    function test_blockRangeLib_withEndBlock() public pure {
        BlockRange memory range = blockRangeFrom(50);
        range = BlockRangeLib.withEndBlock(range, 150);
        assertEq(uint256(range.kind), uint256(BlockRangeKind.RangeInclusive));
        assertEq(range.startBlockInclusive, 50);
        assertEq(range.endBlockInclusive, 150);
    }

    function test_chainToChainId() public pure {
        assertEq(chainToChainId(Chains.Ethereum), 1);
        assertEq(chainToChainId(Chains.Arbitrum), 42161);
        assertEq(chainToChainId(Chains.Base), 8453);
        assertEq(chainToChainId(Chains.Optimism), 10);
    }

    function test_chainsLib_withStartBlock() public pure {
        ChainWithRange memory chain = ChainsLib.withStartBlock(Chains.Ethereum, 1000);
        assertEq(chain.chainId, 1);
        assertEq(uint256(chain.blockRange.kind), uint256(BlockRangeKind.RangeFrom));
        assertEq(chain.blockRange.startBlockInclusive, 1000);
    }

    function test_chainsLib_withEndBlock() public pure {
        ChainWithRange memory chain = ChainsLib.withStartBlock(Chains.Base, 500);
        chain = ChainsLib.withEndBlock(chain, 1500);
        assertEq(chain.chainId, 8453);
        assertEq(uint256(chain.blockRange.kind), uint256(BlockRangeKind.RangeInclusive));
        assertEq(chain.blockRange.startBlockInclusive, 500);
        assertEq(chain.blockRange.endBlockInclusive, 1500);
    }

    function test_chainContract() public pure {
        address testContract = address(0x1234);
        ChainIdContract memory t = chainContract(Chains.Ethereum, testContract);
        assertEq(t.chainId, 1);
        assertEq(t.contractAddress, testContract);
        assertEq(uint256(t.blockRange.kind), uint256(BlockRangeKind.RangeFull));
    }

    function test_chainAbi() public pure {
        Abi memory a = Abi({name: "TestABI"});
        ChainIdAbi memory abiContract = chainAbi(Chains.Arbitrum, a);
        assertEq(abiContract.chainId, 42161);
        assertEq(abiContract.abi.name, "TestABI");
        assertEq(uint256(abiContract.blockRange.kind), uint256(BlockRangeKind.RangeFull));
    }

    function test_chainGlobal() public pure {
        ChainIdGlobal memory g = chainGlobal(Chains.Base);
        assertEq(g.chainId, 8453);
        assertEq(uint256(g.blockRange.kind), uint256(BlockRangeKind.RangeFull));
    }
}
