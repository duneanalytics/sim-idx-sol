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
    address callee;
     // Address of the EOA / contract that invoked the current one
    address caller;      
    // The calldata of the current call
    bytes callData;
    // The depth of the current call
    uint256 callDepth;
    // Value transferred (in wei)
    uint256 value;
    // The type of call
    CallType callType;
    // The verification source of the current contract
    ContractVerificationSource verificationSource;
}

struct TransactionContext {
    // The execution context of the current call
    CallFrame call;
    // Top level transaction hash
    bytes32 hash;
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
