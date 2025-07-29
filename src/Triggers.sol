// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

enum Chains {
    Ethereum, // 1
    EthereumSepolia, // 11155111
    Base, // 8453
    BaseSepolia, // 84532
    WorldChain, // 480
    Mode, // 34443
    Ink, // 57073
    Unichain, // 130
    Zora, // 7777777
    BOB, // 60808
    Soneium, // 1868
    Shape // 360

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

struct UnboundedBlockRange {
    Chains chain;
    uint256 startBlock;
}

struct BoundedBlockRange {
    Chains chain;
    uint256 startBlock;
    uint256 endBlock;
}

enum BlockRangeKind {
    UNBOUNDED,
    BOUNDED
}

struct BlockRange {
    BlockRangeKind kind;
    uint256 startBlock;
    uint256 endBlock;
}

function unboundedBlockRange(uint256 startBlock) pure returns (BlockRange memory) {
    return BlockRange({kind: BlockRangeKind.UNBOUNDED, startBlock: startBlock, endBlock: type(uint256).max});
}

function boundedBlockRange(uint256 startBlock, uint256 endBlock) pure returns (BlockRange memory) {
    return BlockRange({kind: BlockRangeKind.BOUNDED, startBlock: startBlock, endBlock: endBlock});
}

library BlockRangeLibrary {
    function isUnbounded(BlockRange memory range) public pure returns (bool) {
        return range.kind == BlockRangeKind.UNBOUNDED;
    }
}

using BlockRangeLibrary for BlockRange global;

library ChainLibrary {
    // or fromBlock?
    function withStartBlock(Chains chain, uint256 startBlock) internal pure returns (UnboundedBlockRange memory) {
        // Return data type likely need to be unified `ChainIdContract` etc.
        return UnboundedBlockRange({chain: chain, startBlock: startBlock});
    }

    function withRange(Chains chain, uint256 startBlock, uint256 endBlock)
        internal
        pure
        returns (BoundedBlockRange memory)
    {
        return BoundedBlockRange({chain: chain, startBlock: startBlock, endBlock: endBlock});
    }

    function withRange(Chains chain, BlockRange memory range) internal pure returns (BoundedBlockRange memory) {
        return BoundedBlockRange({chain: chain, startBlock: range.startBlock, endBlock: range.endBlock});
    }
}

using ChainLibrary for Chains global;

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
    BlockRange blockRange;
}

struct RawTrigger {
    RawTriggerType triggerType;
    bytes32 handlerSelector;
    bytes32 listenerCodehash;
    BlockRange blockRange;
}

struct ContractTarget {
    ChainIdContract targetContract;
    Trigger trigger;
    bytes32 handlerSelector;
    bytes32 listenerCodehash;
}

struct ChainIdContract {
    uint256 chainId;
    address contractAddress;
    BlockRange blockRange;
}

function chainContract(UnboundedBlockRange memory blockRange, address contractAddress)
    pure
    returns (ChainIdContract memory)
{
    Chains chainId = blockRange.chain;
    return ChainIdContract({
        chainId: chainToChainId(chainId),
        contractAddress: contractAddress,
        blockRange: unboundedBlockRange(1)
    });
}

function chainContract(BoundedBlockRange memory blockRange, address contractAddress)
    pure
    returns (ChainIdContract memory)
{
    Chains chainId = blockRange.chain;
    return ChainIdContract({
        chainId: chainToChainId(chainId),
        contractAddress: contractAddress,
        blockRange: unboundedBlockRange(1)
    });
}

function chainContract(Chains chain, address contractAddress) pure returns (ChainIdContract memory) {
    return ChainIdContract({
        chainId: chainToChainId(chain),
        contractAddress: contractAddress,
        blockRange: unboundedBlockRange(1)
    });
}

struct Abi {
    string name;
}

struct AbiTarget {
    ChainIdAbi targetAbi;
    Trigger trigger;
    bytes32 handlerSelector;
    bytes32 listenerCodehash;
}

struct ChainIdAbi {
    uint256 chainId;
    Abi abi;
    BlockRange blockRange;
}

function chainAbi(Chains chain, Abi memory abiData) pure returns (ChainIdAbi memory) {
    return ChainIdAbi({chainId: chainToChainId(chain), abi: abiData, blockRange: unboundedBlockRange(1)});
}

struct ChainIdGlobal {
    uint256 chainId;
    BlockRange blockRange;
}

function chainGlobal(Chains chain) pure returns (ChainIdGlobal memory) {
    return ChainIdGlobal({chainId: chainToChainId(chain), blockRange: unboundedBlockRange(1)});
}

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
    ChainIdGlobal chainId;
    RawTriggerType triggerType;
    bytes32 handlerSelector;
    bytes32 listenerCodehash;
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
                listenerCodehash: triggerFunction.listenerCodehash
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
                listenerCodehash: triggerFunction.listenerCodehash
            })
        );
    }

    function addTriggers(ChainIdAbi memory targetAbi, Trigger[] memory triggers_) internal {
        for (uint256 i = 0; i < triggers_.length; i++) {
            addTrigger(targetAbi, triggers_[i]);
        }
    }

    function addTrigger(ChainIdGlobal memory chainId, RawTrigger memory trigger) internal {
        _globalTargets.push(
            GlobalTarget({
                chainId: chainId,
                triggerType: trigger.triggerType,
                handlerSelector: trigger.handlerSelector,
                listenerCodehash: trigger.listenerCodehash
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
