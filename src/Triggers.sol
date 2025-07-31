// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

enum BlockRangeKind {
    BOUNDED,                // (custom start, custom end)
    FROM_BLOCK,             // (custom start, infinity)
    FULL_SYNC               // (earliest available, infinity)
}

struct BlockRange {
    BlockRangeKind kind;
    uint64 startBlock;
    uint64 endBlock;
}

library BlockRangeLib {
    function withStartBlock(uint64 blockNum) internal pure returns (BlockRange memory) {
        return BlockRange({kind: BlockRangeKind.FROM_BLOCK, startBlock: blockNum, endBlock: 0});
    }

    function withEndBlock(BlockRange memory range, uint64 endBlock) internal pure returns (BlockRange memory) {
        range.endBlock = endBlock;
        range.kind = BlockRangeKind.BOUNDED;
        return range;
    }
}

using BlockRangeLib for BlockRange global;

function fullSync() pure returns (BlockRange memory) {
    return BlockRange({kind: BlockRangeKind.FULL_SYNC, startBlock: 0, endBlock: 0});
}

function fromBlock(uint64 startBlock) pure returns (BlockRange memory) {
    return BlockRangeLib.withStartBlock(startBlock);
}

function createBlockRange(uint64 startBlock, uint64 endBlock) pure returns (BlockRange memory) {
    return BlockRangeLib.withStartBlock(startBlock).withEndBlock(endBlock);
}

enum Chains {
    Ethereum,           // 1
    EthereumSepolia,    // 11155111
    Base,               // 8453
    BaseSepolia,        // 84532
    WorldChain,         // 480
    Mode,               // 34443
    Ink,                // 57073
    Unichain,           // 130
    Zora,               // 7777777
    BOB,                // 60808
    Soneium,            // 1868
    Shape               // 360
}

function chainToChainId(Chains chain) pure returns (uint256) {
    if (chain == Chains.Ethereum) return 1;
    if (chain == Chains.EthereumSepolia) return 11155111;
    if (chain == Chains.Base) return 8453;
    if (chain == Chains.BaseSepolia) return 84532;
    if (chain == Chains.WorldChain) return 480;
    if (chain == Chains.Mode) return 34443;
    if (chain == Chains.Ink) return 57073;
    if (chain == Chains.Unichain) return 130;
    if (chain == Chains.Zora) return 7777777;
    if (chain == Chains.BOB) return 60808;
    if (chain == Chains.Soneium) return 1868;
    if (chain == Chains.Shape) return 360;
    revert("Unsupported chain");
}

enum TriggerType {
    FUNCTION,
    EVENT,
    PRE_FUNCTION
}

enum RawTriggerType {
    CALL,
    PRE_CALL,
    BLOCK,
    LOG
}

struct Trigger {
    string abiName;
    bytes32 selector;
    TriggerType triggerType;
    bytes32 listenerCodehash;
    bytes32 handlerSelector;
}

struct RawTrigger {
    RawTriggerType triggerType;
    bytes32 handlerSelector;
    bytes32 listenerCodehash;
}

struct ContractTarget {
    ChainIdContract targetContract;
    Trigger trigger;
    bytes32 handlerSelector;
    bytes32 listenerCodehash;
    BlockRange blockRange;
}

struct ChainIdContract {
    uint256 chainId;
    address contractAddress;
    BlockRange blockRange;
}

function chainContract(Chains chain, address contractAddress) pure returns (ChainIdContract memory) {
    return ChainIdContract({chainId: chainToChainId(chain), contractAddress: contractAddress, blockRange: fullSync()});
}

library ChainContractLibrary {
    function withBlockRange(ChainIdContract memory chain, BlockRange memory newBlockRange)
        internal
        pure
        returns (ChainIdContract memory)
    {
        chain.blockRange = newBlockRange;
        return chain;
    }
}

using ChainContractLibrary for ChainIdContract global;

struct Abi {
    string name;
}

struct AbiTarget {
    ChainIdAbi targetAbi;
    Trigger trigger;
    bytes32 handlerSelector;
    bytes32 listenerCodehash;
    BlockRange blockRange;
}

struct ChainIdAbi {
    uint256 chainId;
    Abi abi;
    BlockRange blockRange;
}

function chainAbi(Chains chain, Abi memory abiData) pure returns (ChainIdAbi memory) {
    return ChainIdAbi({chainId: chainToChainId(chain), abi: abiData, blockRange: fullSync()});
}

library AbiLibrary {
    function withBlockRange(ChainIdAbi memory chain, BlockRange memory newBlockRange)
        internal
        pure
        returns (ChainIdAbi memory)
    {
        chain.blockRange = newBlockRange;
        return chain;
    }
}

using AbiLibrary for ChainIdAbi global;

struct ChainIdGlobal {
    uint256 chainId;
    BlockRange blockRange;
}

function chainGlobal(Chains chain) pure returns (ChainIdGlobal memory) {
    return ChainIdGlobal({chainId: chainToChainId(chain), blockRange: fullSync()});
}

library ChainGlobalLibrary {
    function withBlockRange(ChainIdGlobal memory chainId, BlockRange memory newBlockRange)
        internal
        pure
        returns (ChainIdGlobal memory)
    {
        chainId.blockRange = newBlockRange;
        return chainId;
    }
}

using ChainGlobalLibrary for ChainIdGlobal global;

struct CustomTriggerContractTarget {
    ChainIdContract targetContract;
    bytes32 handlerSelector;
    bytes32 listenerCodehash;
}

struct CustomTriggerTypeAbiTarget {
    ChainIdAbi targetAbi;
    bytes32 handlerSelector;
    bytes32 listenerCodehash;
}

struct GlobalTarget {
    uint256 chainId;
    RawTriggerType triggerType;
    bytes32 handlerSelector;
    bytes32 listenerCodehash;
    BlockRange blockRange;
}

abstract contract BaseTriggers {
    ContractTarget[] _contractTargets;
    AbiTarget[] _abiTargets;
    GlobalTarget[] _globalTargets;

    function triggers() external virtual;

    function addTrigger(ChainIdContract memory targetContract, Trigger memory triggerFunction) internal {
        _contractTargets.push(
            ContractTarget({
                targetContract: targetContract,
                trigger: triggerFunction,
                handlerSelector: triggerFunction.handlerSelector,
                listenerCodehash: triggerFunction.listenerCodehash,
                blockRange: targetContract.blockRange
            })
        );
    }

    function addTriggers(ChainIdContract memory targetContract, Trigger[] memory triggers_) internal {
        for (uint256 i = 0; i < triggers_.length; i++) {
            addTrigger(targetContract, triggers_[i]);
        }
    }

    function addTrigger(ChainIdAbi memory targetAbi, Trigger memory triggerFunction) internal {
        _abiTargets.push(
            AbiTarget({
                targetAbi: targetAbi,
                trigger: triggerFunction,
                handlerSelector: triggerFunction.handlerSelector,
                listenerCodehash: triggerFunction.listenerCodehash,
                blockRange: targetAbi.blockRange
            })
        );
    }

    function addTriggers(ChainIdAbi memory targetAbi, Trigger[] memory triggers_) internal {
        for (uint256 i = 0; i < triggers_.length; i++) {
            addTrigger(targetAbi, triggers_[i]);
        }
    }

    function addTrigger(ChainIdGlobal memory chain, RawTrigger memory trigger) internal {
        _globalTargets.push(
            GlobalTarget({
                chainId: chain.chainId,
                triggerType: trigger.triggerType,
                handlerSelector: trigger.handlerSelector,
                listenerCodehash: trigger.listenerCodehash,
                blockRange: chain.blockRange
            })
        );
    }

    function addTriggers(ChainIdGlobal memory chainId, RawTrigger[] memory triggers_) internal {
        for (uint256 i = 0; i < triggers_.length; i++) {
            addTrigger(chainId, triggers_[i]);
        }
    }

    function getSimTargets()
        external
        view
        returns (AbiTarget[] memory, ContractTarget[] memory, GlobalTarget[] memory)
    {
        return (_abiTargets, _contractTargets, _globalTargets);
    }
}
