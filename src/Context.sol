// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

/// @title Context Types and Structures
/// @notice Defines all context types and structures used for blockchain event and transaction processing
/// @dev This file contains the core data structures used to represent execution contexts across different trigger types

/// @notice Enumeration of contract identification methods
/// @dev Used to identify whether a contract was identified through verified source code or bytecode analysis
enum ContractVerificationSource {
    /// @dev No verification method specified
    Unspecified,
    /// @dev Contract verified using ABI information
    ABI,
    /// @dev Contract verified using bytecode analysis
    Bytecode
}

/// @notice Enumeration of EVM call types
/// @dev Comprehensive list of all possible call types in the Ethereum Virtual Machine
enum CallType {
    /// @dev Standard external call to another contract
    CALL,
    /// @dev Legacy call type that executes code in caller's context
    CALLCODE,
    /// @dev Read-only call that cannot modify state
    STATICCALL,
    /// @dev Call that executes code in caller's context with caller's storage
    DELEGATECALL,
    /// @dev Contract creation using CREATE opcode
    CREATE,
    /// @dev Contract creation using CREATE2 opcode with deterministic address
    CREATE2,
    /// @dev Initial contract deployment transaction
    DEPLOYMENT,
    /// @dev Fallback for unrecognized call types
    UNKNOWN
}

/// @notice Uniquely identifies the location and context of blockchain events
struct OrdinalComponents {
    /// @notice Function that returns the block number where the execution occurred
    /// @dev The height of the block in the blockchain
    function () external returns (uint32) blockNumber;
    /// @notice Function that returns the chain reorganization state
    /// @dev The reorg incarnation number for this block
    function () external returns (uint32) reorgIncarnation;
    /// @notice Function that returns the position of the transaction in the block
    /// @dev Zero-based index of transaction within the block
    function () external returns (uint24) txnIndex;
    /// @notice Function that returns the number of instructions executed
    /// @dev Shadow program counter value
    function () external returns (uint40) shadowPc;
}

// Library for OrdinalComponents
library OrdinalComponentsLib {
    /// @notice Creates a 128-bit ordinal from the components
    /// @dev The ordinal is a 128-bit value that is used to uniquely identify a blockchain event
    /// @param components The components to create the ordinal from
    /// @return The 128-bit ordinal
    function createOrdinal(OrdinalComponents memory components) internal returns (uint128) {
        return (uint128(components.blockNumber()) << 96) | (uint128(components.reorgIncarnation()) << 64)
            | (uint128(components.txnIndex()) << 40) | uint128(components.shadowPc());
    }
}

using OrdinalComponentsLib for OrdinalComponents global;

/// @notice Represents the execution frame of a contract call
/// @dev Contains all relevant information about the current execution context including call hierarchy
struct CallFrame {
    /// @notice Function that returns the address of the currently executing contract
    /// @dev The contract whose code is currently being executed
    function () external returns (address) callee;
    /// @notice Function that returns the address that initiated the current call
    /// @dev Could be an EOA or another contract
    function () external returns (address) caller;
    /// @notice Function that returns the address that delegated the current call
    /// @dev Relevant for proxy patterns where execution is delegated
    function () external returns (address) delegator;
    /// @notice Function that returns the address of the implementation contract
    /// @dev The contract that contains the actual implementation code
    function () external returns (address) delegatee;
    /// @notice Function that returns the calldata for the current call
    /// @dev The input data sent with the transaction or call
    function () external returns (bytes memory) callData;
    /// @notice Function that returns the current call depth
    /// @dev How many levels deep the current call is in the call stack
    function () external returns (uint256) callDepth;
    /// @notice Function that returns the value transferred with the call
    /// @dev Amount of wei sent with the call
    function () external returns (uint256) value;
    /// @notice Function that returns the type of the current call
    /// @dev One of the CallType enum values
    function () external returns (CallType) callType;
    /// @notice The method used to verify this contract for indexing
    /// @dev Determines how the contract's functionality was identified
    ContractVerificationSource verificationSource;
}

/// @notice Represents the complete context of a blockchain transaction
/// @dev Contains both call-specific information and transaction-level metadata
struct TransactionContext {
    /// @notice The current execution frame context
    /// @dev Detailed information about the current call being executed
    CallFrame call;
    /// @notice Function that returns whether the transaction succeeded
    /// @dev True if the transaction completed without reverting
    function () external returns (bool) isSuccessful;
    /// @notice Function that returns the transaction hash
    /// @dev The unique identifier for this transaction
    function () external returns (bytes32) hash;
    /// @notice The blockchain network identifier
    /// @dev Chain ID as defined in EIP-155
    uint256 chainId;
    /// @notice The ordinal of the current block
    /// @dev The ordinal of the current block
    OrdinalComponents ordinal;
}

/// @notice Context provided to function-based triggers
/// @dev Used when triggering on specific function calls
struct FunctionContext {
    /// @notice The complete transaction context
    TransactionContext txn;
}

/// @notice Context provided to event-based triggers
/// @dev Used when triggering on emitted events/logs
struct EventContext {
    /// @notice The complete transaction context
    TransactionContext txn;
}

/// @notice Context provided to pre-function triggers
/// @dev Used when triggering before function execution begins
struct PreFunctionContext {
    /// @notice The complete transaction context
    TransactionContext txn;
}

/// @notice Context provided to raw call triggers
/// @dev Used for low-level call monitoring with access to call and return data
struct RawCallContext {
    /// @notice The complete transaction context
    TransactionContext txn;
    /// @notice Function that returns the raw calldata
    /// @dev The complete input data for the call
    function () external returns (bytes memory) callData;
    /// @notice Function that returns the raw return data
    /// @dev The complete output data from the call
    function () external returns (bytes memory) returnData;
}

/// @notice Context provided to raw pre-call triggers
/// @dev Used for low-level monitoring before call execution
struct RawPreCallContext {
    /// @notice The complete transaction context
    TransactionContext txn;
    /// @notice Function that returns the raw calldata
    /// @dev The complete input data for the upcoming call
    function () external returns (bytes memory) callData;
}

/// @notice Context provided to raw log triggers
/// @dev Used for low-level event/log monitoring
struct RawLogContext {
    /// @notice The complete transaction context
    TransactionContext txn;
    /// @notice Function that returns the log topics
    /// @dev Array of indexed event parameters (topics 0-3)
    function () external returns (bytes32[] memory) topics;
    /// @notice Function that returns the log data
    /// @dev The non-indexed event data
    function () external returns (bytes memory) data;
}

/// @notice Context provided to block-based triggers
/// @dev Used for triggers that fire on block events
struct RawBlockContext {
    /// @notice The block number for this context
    /// @dev The height of the block in the blockchain
    uint256 blockNumber;
}
