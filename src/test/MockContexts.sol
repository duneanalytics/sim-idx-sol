// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {
    FunctionContext,
    EventContext,
    CallFrame,
    TransactionContext,
    ContractVerificationSource,
    CallType,
    SimFunctions
} from "../Context.sol";

contract MockContexts {
    address public caller;
    address public callee;
    bytes public callData;
    uint256 public value;
    CallType public callType;
    uint256 public callDepth;
    ContractVerificationSource public verificationSource;
    address public delegatee;
    address public delegator;
    bytes32 public hash;
    bool public isSuccessful;
    uint120 private indexValue;
    uint64 public transactionIndex;
    uint64 public logIndex;

    function mockGlobalIndex() external view returns (uint120) {
        return indexValue;
    }

    function withGlobalIndex(uint120 _index) external returns (MockContexts) {
        indexValue = _index;
        return this;
    }

    function mockFunctionContext() external view returns (FunctionContext memory) {
        return FunctionContext({
            txn: this.mockBaseContext(),
            globalIndex: this.mockGlobalIndex,
            sim: this.mockSimFunctions(),
            isInputDecodingSuccessful: true,
            isOutputDecodingSuccessful: true
        });
    }

    function mockEventContext() external view returns (EventContext memory) {
        return EventContext({
            txn: this.mockBaseContext(),
            globalIndex: this.mockGlobalIndex,
            sim: this.mockSimFunctions(),
            isDecodingSuccessful: true,
            logIndex: this.logIndex
        });
    }

    function mockBaseContext() external view returns (TransactionContext memory) {
        return TransactionContext({
            call: this.mockCallFrame(),
            hash: this.hash,
            isSuccessful: this.isSuccessful,
            chainId: 1,
            transactionIndex: this.transactionIndex
        });
    }

    function mockCallFrame() external view returns (CallFrame memory) {
        return CallFrame({
            caller: this.caller,
            callee: this.callee,
            callData: this.callData,
            value: this.value,
            callType: this.callType,
            callDepth: this.callDepth,
            delegatee: this.delegatee,
            delegator: this.delegator,
            verificationSource: verificationSource
        });
    }

    function withCaller(address _caller) external returns (MockContexts) {
        caller = _caller;
        return this;
    }

    function withCallee(address _callee) external returns (MockContexts) {
        callee = _callee;
        return this;
    }

    function withCallData(bytes memory _callData) external returns (MockContexts) {
        callData = _callData;
        return this;
    }

    function withValue(uint256 _value) external returns (MockContexts) {
        value = _value;
        return this;
    }

    function withCallType(CallType _callType) external returns (MockContexts) {
        callType = _callType;
        return this;
    }

    function withCallDepth(uint256 _callDepth) external returns (MockContexts) {
        callDepth = _callDepth;
        return this;
    }

    function withVerificationSource(ContractVerificationSource _verificationSource) external returns (MockContexts) {
        verificationSource = _verificationSource;
        return this;
    }

    function withDelegator(address _delegator) external returns (MockContexts) {
        delegator = _delegator;
        return this;
    }

    function withDelegatee(address _delegatee) external returns (MockContexts) {
        delegatee = _delegatee;
        return this;
    }

    function mockSimFunctions() external view returns (SimFunctions memory) {
        SimFunctions memory _sim = SimFunctions({
            getDeployer: this.getDeployer,
            sqlStatementExecute: this.sqlStatementExecute,
            sqlArgBool: this.sqlArgBool,
            sqlArgInt64: this.sqlArgInt64,
            sqlArgUint64: this.sqlArgUint64,
            sqlArgUint256: this.sqlArgUint256,
            sqlArgBytes32: this.sqlArgBytes32,
            sqlArgBytes: this.sqlArgBytes,
            sqlArgString: this.sqlArgString,
            sqlArgAddress: this.sqlArgAddress,
            sqlQuery: this.sqlQuery,
            sqlRowCount: this.sqlRowCount,
            sqlArgGetAsBool: this.sqlArgGetAsBool,
            sqlArgGetAsInt64: this.sqlArgGetAsInt64,
            sqlArgGetAsInt256: this.sqlArgGetAsInt256,
            sqlArgGetAsAddress: this.sqlArgGetAsAddress,
            sqlArgGetAsUint64: this.sqlArgGetAsUint64,
            sqlArgGetAsUint256: this.sqlArgGetAsUint256,
            sqlArgGetAsString: this.sqlArgGetAsString,
            sqlArgGetAsBytes: this.sqlArgGetAsBytes,
            sqlArgGetAsBytes32: this.sqlArgGetAsBytes32,
            sqlNextRow: this.sqlNextRow
        });
        return _sim;
    }

    function getDeployer(address) external pure returns (address) {
        return address(0);
    }

    function sqlStatementExecute(string memory) external pure {
        return;
    }

    function sqlArgBool(bool) external pure {
        return;
    }

    function sqlArgInt64(int64) external pure {
        return;
    }

    function sqlArgUint64(uint64) external pure {
        return;
    }

    function sqlArgUint256(uint256) external pure {
        return;
    }

    function sqlArgBytes32(bytes32) external pure {
        return;
    }

    function sqlArgBytes(bytes memory) external pure {
        return;
    }

    function sqlArgString(string memory) external pure {
        return;
    }

    function sqlArgAddress(address) external pure {
        return;
    }

    function sqlArgInt256(int256) external pure {
        return;
    }

    function sqlQuery(string memory) external pure returns (bool) {
        return false;
    }

    function sqlRowCount() external pure returns (uint64) {
        return 0;
    }

    function sqlArgGetAsBool(string memory) external pure returns (bool) {
        return false;
    }

    function sqlArgGetAsInt64(string memory) external pure returns (int64) {
        return 0;
    }

    function sqlArgGetAsInt256(string memory) external pure returns (int256) {
        return 0;
    }

    function sqlArgGetAsAddress(string memory) external pure returns (address) {
        return address(0);
    }

    function sqlArgGetAsUint64(string memory) external pure returns (uint64) {
        return 0;
    }

    function sqlArgGetAsUint256(string memory) external pure returns (uint256) {
        return 0;
    }

    function sqlArgGetAsString(string memory) external pure returns (string memory) {
        return "";
    }

    function sqlArgGetAsBytes(string memory) external pure returns (bytes memory) {
        return "";
    }

    function sqlArgGetAsBytes32(string memory) external pure returns (bytes32) {
        return bytes32(0);
    }

    function sqlNextRow() external pure returns (bool) {
        return false;
    }

    function withTransactionIndex(uint64 _transactionIndex) external returns (MockContexts) {
        transactionIndex = _transactionIndex;
        return this;
    }

    function withLogIndex(uint64 _logIndex) external returns (MockContexts) {
        logIndex = _logIndex;
        return this;
    }
}
