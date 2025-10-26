// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {GlobalIndexLib} from "../src/libs/GlobalIndex.sol";
import {MockContexts} from "../src/test/MockContexts.sol";

contract GlobalIndexTest is Test {
    uint32 private constant BLOCK_NUMBER = type(uint32).max;
    uint24 private constant REORG_INCARNATION = type(uint24).max;
    uint24 private constant TXN_INDEX = type(uint24).max;
    uint40 private constant SHADOW_PC = type(uint40).max;

    function test_GlobalIndex() public pure {
        // Create a global index
        uint120 index = (uint120(BLOCK_NUMBER) << 88) | (uint120(REORG_INCARNATION) << 64) | (uint120(TXN_INDEX) << 40)
            | uint120(SHADOW_PC);
        assertEq(index, 1329227995784915872903807060280344575, "Global index computation incorrect");

        // Test component extraction
        assertEq(GlobalIndexLib.getBlockNumber(index), BLOCK_NUMBER, "Block number extraction incorrect");
        assertEq(GlobalIndexLib.getReorgIncarnation(index), REORG_INCARNATION, "Reorg incarnation extraction incorrect");
        assertEq(GlobalIndexLib.getTxnIndex(index), TXN_INDEX, "Transaction index extraction incorrect");
        assertEq(GlobalIndexLib.getShadowPc(index), SHADOW_PC, "Shadow PC extraction incorrect");
    }

    function test_MockContexts() public {
        MockContexts mock = new MockContexts();
        uint120 index = 0xf00dbabe;
        mock.withGlobalIndex(index);

        assertEq(mock.mockGlobalIndex(), index, "Mock global index incorrect");
    }
}
