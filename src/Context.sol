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
    function () external view returns (address) callee;    
     // Address of the EOA / contract that invoked the current one
    function () external view returns (address) caller;      
    // Address of the EOA / contract that delegated the current call (proxy)
    function () external view returns (address) delegator;
    // Address of the contract that was delegated to (implementation)
    function () external view returns (address) delegatee;
    // The calldata of the current call
    function () external view returns (bytes memory)  callData;
    // The depth of the current call
    function () external view returns (uint256)  callDepth;
    // Value transferred (in wei)
    function () external view returns (uint256)  value;
    // The type of call
    function () external view returns (CallType) callType;
    // The verification source of the current contract
    function () external view returns (ContractVerificationSource) verificationSource;
}

struct TransactionContext {
    // The execution context of the current call
    function () external view returns (CallFrame memory) call;
    // Top level transaction hash
    bytes32 hash;
    // Network chain identifier
    uint256 chainId; 
    // Whether the external transaction is successful or reverted
    bool isSuccessful;
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
    bytes callData;
    bytes returnData;
}

struct RawPreCallContext {
    TransactionContext txn;
    bytes callData;
}

struct RawLogContext {
    TransactionContext txn;
    // The topics of the log
    bytes32[] topics;
    // The data of the log
    bytes data;
}

struct RawBlockContext {
  uint256 blockNumber;
}
