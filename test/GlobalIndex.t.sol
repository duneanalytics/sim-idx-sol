// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {GlobalIndexLib} from "../src/Context.sol";
import {MockContexts} from "../src/test/MockContexts.sol";

contract GlobalIndexTest is Test {
    uint32 private constant BLOCK_NUMBER = 123456;
    uint32 private constant REORG_INCARNATION = 7890;
    uint24 private constant TXN_INDEX = 1234;
    uint40 private constant SHADOW_PC = 567890;

    function test_GlobalIndex() public pure {
        // Create a global index
        uint128 index = (uint128(BLOCK_NUMBER) << 96) | (uint128(REORG_INCARNATION) << 64) | (uint128(TXN_INDEX) << 40)
            | uint128(SHADOW_PC);

        // Test the expected value hasn't changed
        assertEq(index, 9781192031506562874046927644174930, "Global index computation incorrect");

        // Test component extraction
        assertEq(GlobalIndexLib.getBlockNumber(index), BLOCK_NUMBER, "Block number extraction incorrect");
        assertEq(GlobalIndexLib.getReorgIncarnation(index), REORG_INCARNATION, "Reorg incarnation extraction incorrect");
        assertEq(GlobalIndexLib.getTxnIndex(index), TXN_INDEX, "Transaction index extraction incorrect");
        assertEq(GlobalIndexLib.getShadowPc(index), SHADOW_PC, "Shadow PC extraction incorrect");
    }

    function test_MockContexts() public {
        MockContexts mock = new MockContexts();
        uint128 index = (uint128(BLOCK_NUMBER) << 96) | (uint128(REORG_INCARNATION) << 64) | (uint128(TXN_INDEX) << 40)
            | uint128(SHADOW_PC);

        mock.withGlobalIndex(index);
        assertEq(mock.mockGlobalIndex(), index, "Mock global index incorrect");
    }
}
