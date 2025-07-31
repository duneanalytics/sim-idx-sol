// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

enum ContractVerificationSource {
    Unspecified,
    ABI,
    Bytecode
}

enum CallType {
  CALL,
  CALLCODE,
  STATICCALL,
  DELEGATECALL,
  CREATE,
  CREATE2,
  DEPLOYMENT,
  UNKNOWN
}

struct CallFrame {
     // Address of the currently executing contract 
    function () external returns (address) callee;    
     // Address of the EOA / contract that invoked the current one
    function () external returns (address) caller;      
    // Address of the EOA / contract that delegated the current call (proxy)
    function () external returns (address) delegator;
    // Address of the contract that was delegated to (implementation)
    function () external returns (address) delegatee;
    // The calldata of the current call
    function () external returns (bytes memory)  callData;
    // The depth of the current call
    function () external returns (uint256)  callDepth;
    // Value transferred (in wei)
    function () external returns (uint256)  value;
    // The type of call
    function () external returns (CallType) callType;
    // The verification source of the current contract
    ContractVerificationSource verificationSource;
}

struct TransactionContext {
    // The execution context of the current call
    CallFrame  call;
    // Whether the external transaction is successful or reverted
    function () external returns (bool) isSuccessful;
    // Top level transaction hash
    function () external returns (bytes32) hash;
    // Network chain identifier
    uint256 chainId; 
}

struct FunctionContext {
  TransactionContext txn;
}

struct EventContext {
    TransactionContext txn;
}

struct PreFunctionContext {
  TransactionContext txn;
}

struct RawCallContext {
    TransactionContext txn;
    function () external returns (bytes memory) callData;
    function () external returns (bytes memory) returnData;
}

struct RawPreCallContext {
    TransactionContext txn;
    function () external returns (bytes memory) callData;
}

struct RawLogContext {
    TransactionContext txn;
    // The topics of the log
    function () external returns (bytes32[] memory) topics;
    // The data of the log
    function () external returns (bytes memory) data;
}

struct RawBlockContext {
  uint256 blockNumber;
}
