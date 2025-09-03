// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {
    FunctionContext,
    EventContext,
    PreFunctionContext,
    RawCallContext,
    RawLogContext,
    RawBlockContext,
    RawPreCallContext
} from "../src/Context.sol";

contract ContextTest is Test {
    // This test verifies that globalIndex exists in all contexts except RawBlockContext
    // The test passes by compilation - if any required field is missing, it won't compile
    function test_GlobalIndexPresence() public pure {
        FunctionContext memory functionCtx;
        EventContext memory eventCtx;
        PreFunctionContext memory preFunctionCtx;
        RawCallContext memory rawCallCtx;
        RawLogContext memory rawLogCtx;
        RawPreCallContext memory rawPreCallCtx;

        // Access the globalIndex field to verify it exists
        // If any of these are missing globalIndex, it won't compile
        functionCtx.globalIndex;
        eventCtx.globalIndex;
        preFunctionCtx.globalIndex;
        rawCallCtx.globalIndex;
        rawLogCtx.globalIndex;
        rawPreCallCtx.globalIndex;
    }
}
