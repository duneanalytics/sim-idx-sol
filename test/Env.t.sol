// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {blockNumber, ARB_SYS_ADDRESS} from "../src/Env.sol";

contract EnvTest is Test {
    mapping(uint256 => uint256) internal chainIdToForkId;

    function setUp() public {
        chainIdToForkId[1] = vm.createFork(vm.rpcUrl("ethereum"));
        chainIdToForkId[42161] = vm.createFork(vm.rpcUrl("arbitrum"));
    }

    function test_blockNumber() public {
        vm.selectFork(chainIdToForkId[1]);
        assertEq(vm.activeFork(), chainIdToForkId[1]);

        vm.rollFork(23718054);
        assertEq(block.number, 23718054);
        assertEq(blockNumber(), 23718054);
    }

    function test_blockNumber_arbitrum() public {
        vm.selectFork(chainIdToForkId[42161]);
        assertEq(vm.activeFork(), chainIdToForkId[42161]);

        vm.rollFork(389783281);
        assertEq(block.number, 23583003);
        // should revert with no data because foundry doesn't support the arbsys precompiles
        vm.expectRevert(bytes(""), address(ARB_SYS_ADDRESS));
        blockNumber();
    }
}
