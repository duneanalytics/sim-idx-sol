// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {
    OrdinalComponents,
    FunctionContext,
    EventContext,
    CallFrame,
    TransactionContext,
    ContractVerificationSource,
    CallType
} from "../Context.sol";

contract MockOrdinalComponents {
    uint32 public blockNumber;
    uint32 public reorgIncarnation;
    uint24 public txnIndex;
    uint40 public shadowPc;

    function mockOrdinalComponents() external view returns (OrdinalComponents memory) {
        return OrdinalComponents({
            blockNumber: this.blockNumber,
            reorgIncarnation: this.reorgIncarnation,
            txnIndex: this.txnIndex,
            shadowPc: this.shadowPc
        });
    }

    function withBlockNumber(uint32 _blockNumber) external returns (MockOrdinalComponents) {
        blockNumber = _blockNumber;
        return this;
    }

    function withReorgIncarnation(uint32 _reorgIncarnation) external returns (MockOrdinalComponents) {
        reorgIncarnation = _reorgIncarnation;
        return this;
    }

    function withTxnIndex(uint24 _txnIndex) external returns (MockOrdinalComponents) {
        txnIndex = _txnIndex;
        return this;
    }

    function withShadowPc(uint40 _shadowPc) external returns (MockOrdinalComponents) {
        shadowPc = _shadowPc;
        return this;
    }
}

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
    MockOrdinalComponents public ordinalComponents = new MockOrdinalComponents();

    function mockFunctionContext() external view returns (FunctionContext memory) {
        return FunctionContext({txn: this.mockBaseContext()});
    }

    function mockEventContext() external view returns (EventContext memory) {
        return EventContext({txn: this.mockBaseContext()});
    }

    function mockBaseContext() external view returns (TransactionContext memory) {
        return TransactionContext({
            call: this.mockCallFrame(),
            hash: this.hash,
            isSuccessful: this.isSuccessful,
            chainId: 1,
            ordinal: ordinalComponents.mockOrdinalComponents()
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
}
