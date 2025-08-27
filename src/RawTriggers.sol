// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @title Raw Trigger Contracts
/// @notice Abstract contracts for implementing low-level EVM triggers
/// @dev Provides base contracts for raw trigger handlers that work at the EVM level

import {RawTriggerType, RawTrigger} from "./Triggers.sol";
import {RawCallContext, RawPreCallContext, RawBlockContext, RawLogContext} from "./Context.sol";

/// @title Raw Call Trigger Handler
/// @notice Abstract contract for handling raw contract calls
/// @dev Implement onCall to handle contract call events
abstract contract Raw$OnCall {
    /// @notice Handler function called when a contract call is made
    /// @param ctx The raw call context containing call details
    /// @dev Must be implemented by derived contracts to process call events
    function onCall(RawCallContext memory ctx) external virtual;

    /// @notice Returns the trigger configuration for call monitoring
    /// @return A RawTrigger configured for CALL type with this contract's handler
    /// @dev Used by the trigger system to register this contract as a call handler
    function triggerOnCall() external view returns (RawTrigger memory) {
        return RawTrigger({
            triggerType: RawTriggerType.CALL,
            handlerSelector: this.onCall.selector,
            listenerCodehash: address(this).codehash
        });
    }
}

/// @title Raw Pre-Call Trigger Handler
/// @notice Abstract contract for handling events before contract calls
/// @dev Implement onPreCall to handle pre-call events
abstract contract Raw$OnPreCall {
    /// @notice Handler function called before a contract call is made
    /// @param ctx The raw pre-call context containing upcoming call details
    /// @dev Must be implemented by derived contracts to process pre-call events
    function onPreCall(RawPreCallContext memory ctx) external virtual;

    /// @notice Returns the trigger configuration for pre-call monitoring
    /// @return A RawTrigger configured for PRE_CALL type with this contract's handler
    /// @dev Used by the trigger system to register this contract as a pre-call handler
    function triggerOnPreCall() external view returns (RawTrigger memory) {
        return RawTrigger({
            triggerType: RawTriggerType.PRE_CALL,
            handlerSelector: this.onPreCall.selector,
            listenerCodehash: address(this).codehash
        });
    }
}

/// @title Raw Block Trigger Handler
/// @notice Abstract contract for handling block events
/// @dev Implement onBlock to handle block events
abstract contract Raw$OnBlock {
    /// @notice Handler function called when a new block is processed
    /// @param ctx The raw block context containing block details
    /// @dev Must be implemented by derived contracts to process block events
    function onBlock(RawBlockContext memory ctx) external virtual;

    /// @notice Returns the trigger configuration for block monitoring
    /// @return A RawTrigger configured for BLOCK type with this contract's handler
    /// @dev Used by the trigger system to register this contract as a block handler
    function triggerOnBlock() external view returns (RawTrigger memory) {
        return RawTrigger({
            triggerType: RawTriggerType.BLOCK,
            handlerSelector: this.onBlock.selector,
            listenerCodehash: address(this).codehash
        });
    }
}

/// @title Raw Log Trigger Handler
/// @notice Abstract contract for handling raw log/event emissions
/// @dev Implement onLog to handle log events at the EVM level
abstract contract Raw$OnLog {
    /// @notice Handler function called when a log/event is emitted
    /// @param ctx The raw log context containing log details
    /// @dev Must be implemented by derived contracts to process log events
    function onLog(RawLogContext memory ctx) external virtual;

    /// @notice Returns the trigger configuration for log monitoring
    /// @return A RawTrigger configured for LOG type with this contract's handler
    /// @dev Used by the trigger system to register this contract as a log handler
    function triggerOnLog() external view returns (RawTrigger memory) {
        return RawTrigger({
            triggerType: RawTriggerType.LOG,
            handlerSelector: this.onLog.selector,
            listenerCodehash: address(this).codehash
        });
    }
}
