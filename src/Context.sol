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

/// @notice Represents the execution frame of a contract call
/// @dev Contains all relevant information about the current execution context including call hierarchy
struct CallFrame {
    /// @notice Function that returns the address of the currently executing contract
    /// @dev The contract whose code is currently being executed
    function() external returns (address) callee;
    /// @notice Function that returns the address that initiated the current call
    /// @dev Could be an EOA or another contract
    function() external returns (address) caller;
    /// @notice Function that returns the address that delegated the current call
    /// @dev Relevant for proxy patterns where execution is delegated
    function() external returns (address) delegator;
    /// @notice Function that returns the address of the implementation contract
    /// @dev The contract that contains the actual implementation code
    function() external returns (address) delegatee;
    /// @notice Function that returns the calldata for the current call
    /// @dev The input data sent with the transaction or call
    function() external returns (bytes memory) callData;
    /// @notice Function that returns the current call depth
    /// @dev How many levels deep the current call is in the call stack
    function() external returns (uint256) callDepth;
    /// @notice Function that returns the value transferred with the call
    /// @dev Amount of wei sent with the call
    function() external returns (uint256) value;
    /// @notice Function that returns the type of the current call
    /// @dev One of the CallType enum values
    function() external returns (CallType) callType;
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
    function() external returns (bool) isSuccessful;
    /// @notice Function that returns the transaction hash
    /// @dev The unique identifier for this transaction
    function() external returns (bytes32) hash;
    /// @notice The blockchain network identifier
    /// @dev Chain ID as defined in EIP-155
    uint256 chainId;
    /// @notice Function that returns the transaction index in the block
    /// @dev The position of the transaction in the block
    function() external returns (uint64) transactionIndex;
}

// @noticed Special functions for state access
// @dev These functions are used to access information which is otherwise hard to get
struct SimFunctions {
    /// @notice Function that returns the deployer of a contract
    /// @dev The address of the account that deployed the contract
    function(address) external returns (address) getDeployer;

    /// @notice Function that executes a SQL statement. It can use bind parameters.
    ///         Bind parameters are represented by $<number> where number is the
    ///         position of the parameter. For example, $1 is the first parameter,
    ///         $2 is the second parameter, etc.
    /// @dev The SQL statement to execute
    function(string memory) external sqlStatementExecute;

    /// @notice Function that adds a boolean argument to the SQL statement
    /// @dev The boolean value to add
    function(bool) external sqlArgBool;

    /// @notice Function that adds an int64 argument to the SQL statement
    /// @dev The int64 value to add
    function(int64) external sqlArgInt64;

    /// @notice Function that adds a uint64 argument to the SQL statement
    /// @dev The uint64 value to add
    function(uint64) external sqlArgUint64;

    /// @notice Function that adds a uint256 argument to the SQL statement
    /// @dev The uint256 value to add
    function(uint256) external sqlArgUint256;

    /// @notice Function that adds a bytes32 argument to the SQL statement
    /// @dev The bytes32 value to add
    function(bytes32) external sqlArgBytes32;

    /// @notice Function that adds a bytes argument to the SQL statement
    /// @dev The bytes value to add
    function(bytes memory) external sqlArgBytes;

    /// @notice Function that adds a string argument to the SQL statement
    /// @dev The string value to add
    function(string memory) external sqlArgString;

    /// @notice Function that adds an address argument to the SQL statement
    /// @dev The address value to add
    function(address) external sqlArgAddress;

    /// @notice Function that executes a SQL SELECT query. It can use bind parameters.
    ///         Bind parameters are represented by $<number> where number is the
    ///         position of the parameter. For example, $1 is the first parameter,
    ///         $2 is the second parameter, etc.
    /// @dev The SQL statement to execute
    /// @return hasResult True if the query returned results
    function(string memory) external returns (bool) sqlQuery;

    /// @notice Function that returns the number of rows in the current result.
    /// @dev Gets the row count from the last query
    /// @return rowCount The number of rows in the result set
    function() external returns (uint64) sqlRowCount;

    /// @notice Function that retrieves a boolean value from the requested column
    /// @dev Gets a boolean from the specified column in the current row
    /// @return value The boolean value from the specified column
    function(string memory) external returns (bool) sqlArgGetAsBool;

    /// @notice Function that retrieves an int64 value from the requested column
    /// @dev Gets an int64 from the specified column in the current row
    /// @return value The int64 value from the specified column
    function(string memory) external returns (int64) sqlArgGetAsInt64;

    /// @notice Function that retrieves an int256 value from the requested column
    /// @dev Gets an int256 from the specified column in the current row
    /// @return value The int256 value from the specified column
    function(string memory) external returns (int256) sqlArgGetAsInt256;

    /// @notice Function that retrieves an address value from the requested column
    /// @dev Gets an address from the specified column in the current row
    /// @return value The address value from the specified column
    function(string memory) external returns (address) sqlArgGetAsAddress;

    /// @notice Function that retrieves a uint64 value from the requested column
    /// @dev Gets a uint64 from the specified column in the current row
    /// @return value The uint64 value from the specified column
    function(string memory) external returns (uint64) sqlArgGetAsUint64;

    /// @notice Function that retrieves a uint256 value from the requested column
    /// @dev Gets a uint256 from the specified column in the current row
    /// @return value The uint256 value from the specified column
    function(string memory) external returns (uint256) sqlArgGetAsUint256;

    /// @notice Function that retrieves a string value from the requested column
    /// @dev Gets a string from the specified column in the current row
    /// @return value The string value from the specified column
    function(string memory) external returns (string memory) sqlArgGetAsString;

    /// @notice Function that retrieves a bytes value from the requested column
    /// @dev Gets bytes from the specified column in the current row
    /// @return value The bytes value from the specified column
    function(string memory) external returns (bytes memory) sqlArgGetAsBytes;

    /// @notice Function that retrieves a bytes32 value from the requested column
    /// @dev Gets a bytes32 from the specified column in the current row
    /// @return value The bytes32 value from the specified column
    function(string memory) external returns (bytes32) sqlArgGetAsBytes32;

    /// @notice Function that advances to the next row in the result set
    /// @dev Moves the cursor to the next row, returns false if no more rows
    /// @return hasMoreRows True if there are more rows to fetch
    function() external returns (bool) sqlNextRow;
}

/// @notice Context provided to function-based triggers
/// @dev Used when triggering on specific function calls
struct FunctionContext {
    /// @notice The complete transaction context
    TransactionContext txn;
    /// @notice The special functions for state access
    /// @dev These functions are used to access information which is otherwise hard to get
    SimFunctions sim;
    /// @notice The global index of the current execution
    /// @dev A unique identifier that orders blockchain events globally
    function() external returns (uint120) globalIndex;
    // @notice Whether the function call input was decoded successfully
    // @dev If the function call input was decoded successfully, this will be true
    bool isInputDecodingSuccessful;
    // @notice Whether the function call output was decoded successfully
    // @dev If the function call output was decoded successfully, this will be true
    bool isOutputDecodingSuccessful;
}

/// @notice Context provided to event-based triggers
/// @dev Used when triggering on emitted events/logs
struct EventContext {
    /// @notice The complete transaction context
    TransactionContext txn;
    /// @notice The special functions for state access
    /// @dev These functions are used to access information which is otherwise hard to get
    SimFunctions sim;
    /// @notice The global index of the current execution
    /// @dev A unique identifier that orders blockchain events globally
    function() external returns (uint120) globalIndex;
    // @notice Whether the event log was decoded successfully
    // @dev If the event log was decoded successfully, this will be true
    bool isDecodingSuccessful;
    /// @notice Function that returns the log index in the block
    /// @dev The position of the log entry in the block
    function() external returns (uint64) logIndex;
}

/// @notice Context provided to pre-function triggers
/// @dev Used when triggering before function execution begins
struct PreFunctionContext {
    /// @notice The complete transaction context
    TransactionContext txn;
    /// @notice The special functions for state access
    /// @dev These functions are used to access information which is otherwise hard to get
    SimFunctions sim;
    /// @notice The global index of the current execution
    /// @dev A unique identifier that orders blockchain events globally
    function() external returns (uint120) globalIndex;
    // @notice Whether the function call input was decoded successfully
    // @dev If the function call input was decoded successfully, this will be true
    bool isInputDecodingSuccessful;
}

/// @notice Context provided to raw call triggers
/// @dev Used for low-level call monitoring with access to call and return data
struct RawCallContext {
    /// @notice The complete transaction context
    TransactionContext txn;
    /// @notice The special functions for state access
    /// @dev These functions are used to access information which is otherwise hard to get
    SimFunctions sim;
    /// @notice Function that returns the raw calldata
    /// @dev The complete input data for the call
    function() external returns (bytes memory) callData;
    /// @notice Function that returns the raw return data
    /// @dev The complete output data from the call
    function() external returns (bytes memory) returnData;
    /// @notice The global index of the current execution
    /// @dev A unique identifier that orders blockchain events globally
    function() external returns (uint120) globalIndex;
}

/// @notice Context provided to raw pre-call triggers
/// @dev Used for low-level monitoring before call execution
struct RawPreCallContext {
    /// @notice The complete transaction context
    TransactionContext txn;
    /// @notice The special functions for state access
    /// @dev These functions are used to access information which is otherwise hard to get
    SimFunctions sim;
    /// @notice Function that returns the raw calldata
    /// @dev The complete input data for the upcoming call
    function() external returns (bytes memory) callData;
    /// @notice The global index of the current execution
    /// @dev A unique identifier that orders blockchain events globally
    function() external returns (uint120) globalIndex;
}

/// @notice Context provided to raw log triggers
/// @dev Used for low-level event/log monitoring
struct RawLogContext {
    /// @notice The complete transaction context
    TransactionContext txn;
    /// @notice The special functions for state access
    /// @dev These functions are used to access information which is otherwise hard to get
    SimFunctions sim;
    /// @notice Function that returns the log topics
    /// @dev Array of indexed event parameters (topics 0-3)
    function() external returns (bytes32[] memory) topics;
    /// @notice Function that returns the log data
    /// @dev The non-indexed event data
    function() external returns (bytes memory) data;
    /// @notice The global index of the current execution
    /// @dev A unique identifier that orders blockchain events globally
    function() external returns (uint120) globalIndex;
    /// @notice Function that returns the log index in the block
    /// @dev The position of the log entry in the block
    function() external returns (uint64) logIndex;
}

/// @notice Context provided to block-based triggers
/// @dev Used for triggers that fire on block events
struct RawBlockContext {
    /// @notice The special functions for state access
    /// @dev These functions are used to access information which is otherwise hard to get
    SimFunctions sim;
    /// @notice The block number for this context
    /// @dev The height of the block in the blockchain
    uint256 blockNumber;
}
