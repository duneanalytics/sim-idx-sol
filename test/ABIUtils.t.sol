// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {canBeString, canBeUint256, canBeAddress} from "../src/utils/ABIUtils.sol";

contract ABIUtilsTest is Test {
    function test_fuzzCanBeUint256(bytes memory data) public pure {
        bool result = canBeUint256(data);
        assertEq(result, data.length == 32);
    }

    function test_fuzzCanBeAddress(bytes memory data) public pure {
        bool result = canBeAddress(data);
        if (data.length > 32) {
            assertFalse(result);
        } else {
            // Check if upper bits are zero
            bool upperBitsZero = uint256(bytes32(data)) >> 160 == 0;
            assertEq(result, upperBitsZero);
        }
    }
}
