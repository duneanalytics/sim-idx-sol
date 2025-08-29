// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {OrdinalComponents, OrdinalComponentsLib} from "../src/Context.sol";
import {MockOrdinalComponents} from "../src/test/MockContexts.sol";

contract OrdinalComponentsTest is Test {
    uint32 private constant BLOCK_NUMBER = 123456;
    uint32 private constant REORG_INCARNATION = 7890;
    uint24 private constant TXN_INDEX = 1234;
    uint40 private constant SHADOW_PC = 567890;

    function test_CreateOrdinal() public {
        OrdinalComponents memory components = new MockOrdinalComponents().withBlockNumber(BLOCK_NUMBER)
            .withReorgIncarnation(REORG_INCARNATION).withTxnIndex(TXN_INDEX).withShadowPc(SHADOW_PC).mockOrdinalComponents();

        uint128 ordinal = OrdinalComponentsLib.createOrdinal(components);
        assertEq(ordinal, 9781192031506562874046927644174930, "Ordinal computation incorrect");
    }
}
