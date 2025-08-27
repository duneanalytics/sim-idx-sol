// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import "../src/libs/NativeToken.sol";
import {Chains, chainToChainId, allSupportedChains} from "../src/libs/Chains.sol";

contract NativeTokenTest is Test {
    function test_withChainId() public pure {
        for (uint256 i = 0; i < allSupportedChains().length; i++) {
            NativeToken memory token = NativeTokenLib.withChainId(chainToChainId(allSupportedChains()[i]));
            assertEq(token.name, "Ether");
            assertEq(token.symbol, "ETH");
            assertEq(token.decimals, 18);
        }
    }
}
