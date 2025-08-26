// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {safeReturnAddress, isContract} from "../src/utils/AddressUtils.sol";

contract AddressUtilsTest is Test {
    mapping(uint256 => uint256) internal chainIdToForkId;
    address constant CONTRACT_ADDRESS = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    address constant EOA_ADDRESS = address(0x1234567890123456789012345678901234567890);
    address constant ZERO_ADDRESS = address(0);

    function setUp() public {
        chainIdToForkId[1] = vm.createSelectFork(vm.rpcUrl("ethereum"));
    }

    // Tests for isContract()
    function test_isContract_withContract() public view {
        assertTrue(isContract(CONTRACT_ADDRESS));
    }

    function test_isContract_withEOA() public view {
        assertFalse(isContract(EOA_ADDRESS));
    }

    function test_isContract_withZeroAddress() public view {
        assertFalse(isContract(ZERO_ADDRESS));
    }
}
