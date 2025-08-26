// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import "../src/libs/NativeToken.sol";
import {Chains, chainToChainId} from "../src/libs/Chains.sol";

contract NativeTokenTest is Test {
    function test_withChainId_ethereum() public pure {
        NativeToken memory token = NativeTokenLib.withChainId(chainToChainId(Chains.Ethereum));
        assertEq(token.name, "Ether");
        assertEq(token.symbol, "ETH");
        assertEq(token.decimals, 18);
    }
}
