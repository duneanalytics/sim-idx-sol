// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @notice Enumeration of block range types
/// @dev Defines how block ranges are interpreted for trigger activation
enum BlockRangeKind {
    /// @dev Blocks from inclusive start to inclusive end
    RangeInclusive,
    /// @dev Blocks from inclusive start to unbounded end
    RangeFrom,
    /// @dev All blocks from earliest available to unbounded end
    RangeFull
}

/// @notice Represents a range of blocks for trigger activation
/// @dev Flexible block range specification supporting different range types
struct BlockRange {
    /// @notice The type of block range
    BlockRangeKind kind;
    /// @notice Starting block number (inclusive)
    uint64 startBlockInclusive;
    /// @notice Ending block number (inclusive, 0 if unbounded)
    uint64 endBlockInclusive;
}

/// @title Block Range Library
/// @notice Utility functions for creating and manipulating block ranges
/// @dev Provides fluent API for block range configuration
library BlockRangeLib {
    /// @notice Creates a block range starting from a specific block
    /// @param startBlockInclusive The starting block number (inclusive)
    /// @return A BlockRange configured as RangeFrom
    function withStartBlock(uint64 startBlockInclusive) internal pure returns (BlockRange memory) {
        return
            BlockRange({kind: BlockRangeKind.RangeFrom, startBlockInclusive: startBlockInclusive, endBlockInclusive: 0});
    }

    /// @notice Adds an end block to an existing range, converting it to RangeInclusive
    /// @param range The existing block range to modify
    /// @param endBlockInclusive The ending block number (inclusive)
    /// @return The modified BlockRange with kind set to RangeInclusive
    function withEndBlock(BlockRange memory range, uint64 endBlockInclusive)
        internal
        pure
        returns (BlockRange memory)
    {
        range.endBlockInclusive = endBlockInclusive;
        range.kind = BlockRangeKind.RangeInclusive;
        return range;
    }
}

using BlockRangeLib for BlockRange global;

/// @notice Creates a full range covering all blocks
/// @return A BlockRange configured to cover all available blocks
function blockRangeFull() pure returns (BlockRange memory) {
    return BlockRange({kind: BlockRangeKind.RangeFull, startBlockInclusive: 0, endBlockInclusive: 0});
}

/// @notice Creates a range starting from a specific block to the end
/// @param startBlockInclusive The starting block number (inclusive)
/// @return A BlockRange configured as RangeFrom
function blockRangeFrom(uint64 startBlockInclusive) pure returns (BlockRange memory) {
    return BlockRangeLib.withStartBlock(startBlockInclusive);
}

/// @notice Creates a range with specific start and end blocks
/// @param startBlockInclusive The starting block number (inclusive)
/// @param endBlockInclusive The ending block number (inclusive)
/// @return A BlockRange configured as RangeInclusive
function blockRangeInclusive(uint64 startBlockInclusive, uint64 endBlockInclusive) pure returns (BlockRange memory) {
    return BlockRangeLib.withStartBlock(startBlockInclusive).withEndBlock(endBlockInclusive);
}

/// @notice Enumeration of supported blockchain networks
/// @dev Maps to actual chain IDs as defined in EIP-155
enum Chains {
    /// @dev Ethereum Mainnet (Chain ID: 1)
    Ethereum,
    /// @dev Ethereum Sepolia Testnet (Chain ID: 11155111)
    EthereumSepolia,
    /// @dev Base Mainnet (Chain ID: 8453)
    Base,
    /// @dev Base Sepolia Testnet (Chain ID: 84532)
    BaseSepolia,
    /// @dev World Chain (Chain ID: 480)
    WorldChain,
    /// @dev Mode Network (Chain ID: 34443)
    Mode,
    /// @dev Ink Protocol (Chain ID: 57073)
    Ink,
    /// @dev Unichain (Chain ID: 130)
    Unichain,
    /// @dev Zora Network (Chain ID: 7777777)
    Zora,
    /// @dev BOB Network (Chain ID: 60808)
    BOB,
    /// @dev Soneium Network (Chain ID: 1868)
    Soneium,
    /// @dev Shape Network (Chain ID: 360)
    Shape,
    /// @dev Arbitrum One (Chain ID: 42161)
    Arbitrum,
    /// @dev Optimism Mainnet (Chain ID: 10)
    Optimism
}

/// @notice Maps a Chains enum value to its corresponding EIP-155 chain ID
/// @param chain The blockchain network enum value
/// @return The numeric chain ID as defined in EIP-155
/// @dev Reverts with "Unsupported chain" for unknown chain values
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
    if (chain == Chains.Arbitrum) return 42161;
    if (chain == Chains.Optimism) return 10;
    revert("Unsupported chain");
}

/// @notice Represents a blockchain network with an associated block range
/// @dev Combines chain identification with block range specification
struct ChainWithRange {
    /// @notice The EIP-155 chain ID
    uint256 chainId;
    /// @notice The block range for this chain configuration
    BlockRange blockRange;
}

/// @title Chains Library
/// @notice Utility functions for creating chain configurations with block ranges
/// @dev Provides fluent API for chain and block range configuration
library ChainsLib {
    /// @notice Creates a chain configuration with a starting block
    /// @param chain The blockchain network
    /// @param startBlockInclusive The starting block number (inclusive)
    /// @return A ChainWithRange configured from the specified block
    function withStartBlock(Chains chain, uint64 startBlockInclusive) internal pure returns (ChainWithRange memory) {
        return ChainWithRange({
            chainId: chainToChainId(chain),
            blockRange: BlockRangeLib.withStartBlock(startBlockInclusive)
        });
    }

    /// @notice Adds an end block to an existing chain configuration
    /// @param chain The existing chain configuration to modify
    /// @param endBlockInclusive The ending block number (inclusive)
    /// @return The modified ChainWithRange with an inclusive range
    function withEndBlock(ChainWithRange memory chain, uint64 endBlockInclusive)
        internal
        pure
        returns (ChainWithRange memory)
    {
        chain.blockRange = BlockRangeLib.withEndBlock(chain.blockRange, endBlockInclusive);
        return chain;
    }

    /// @notice Creates a chain configuration with a specific block range
    /// @param chain The blockchain network
    /// @param range The block range to apply
    /// @return A ChainWithRange with the specified range
    function withBlockRange(Chains chain, BlockRange memory range) internal pure returns (ChainWithRange memory) {
        return ChainWithRange({chainId: chainToChainId(chain), blockRange: range});
    }
}

using ChainsLib for Chains global;
using ChainsLib for ChainWithRange global;

/// @notice Enumeration of high-level trigger types
/// @dev Used for ABI-based triggers that understand contract semantics
enum TriggerType {
    /// @dev Triggers on function calls
    FUNCTION,
    /// @dev Triggers on emitted events
    EVENT,
    /// @dev Triggers before function execution
    PRE_FUNCTION
}

/// @notice Enumeration of low-level raw trigger types
/// @dev Used for raw triggers that work at the EVM level
enum RawTriggerType {
    /// @dev Triggers on contract calls
    CALL,
    /// @dev Triggers before contract calls
    PRE_CALL,
    /// @dev Triggers on block events
    BLOCK,
    /// @dev Triggers on log/event emissions
    LOG
}

/// @notice Configuration for high-level ABI-based triggers
/// @dev Contains all information needed to identify and handle ABI-based triggers
struct Trigger {
    /// @notice Name of the ABI this trigger relates to
    string abiName;
    /// @notice Function or event selector (first 4 bytes of signature hash)
    bytes32 selector;
    /// @notice The type of trigger (function, event, or pre-function)
    TriggerType triggerType;
    /// @notice Code hash of the contract containing the handler
    bytes32 listenerCodehash;
    /// @notice Selector of the handler function to call
    bytes32 handlerSelector;
}

/// @notice Configuration for low-level raw triggers
/// @dev Contains information needed for raw EVM-level triggers
struct RawTrigger {
    /// @notice The type of raw trigger
    RawTriggerType triggerType;
    /// @notice Selector of the handler function to call
    bytes32 handlerSelector;
    /// @notice Code hash of the contract containing the handler
    bytes32 listenerCodehash;
}

/// @notice Represents a trigger target for a specific contract
/// @dev Combines contract identification with trigger configuration
struct ContractTarget {
    /// @notice The target contract and chain information
    ChainIdContract targetContract;
    /// @notice The trigger configuration
    Trigger trigger;
    /// @notice Selector of the handler function (duplicated for efficiency)
    bytes32 handlerSelector;
    /// @notice Code hash of the listener contract (duplicated for efficiency)
    bytes32 listenerCodehash;
    /// @notice Block range for this trigger target
    BlockRange blockRange;
}

/// @notice Represents a contract on a specific blockchain
/// @dev Combines chain ID, contract address, and block range
struct ChainIdContract {
    /// @notice The EIP-155 chain ID
    uint256 chainId;
    /// @notice The contract address on the specified chain
    address contractAddress;
    /// @notice The block range for monitoring this contract
    BlockRange blockRange;
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

/// @notice Creates a ChainIdContract for a specific chain and contract address
/// @param chain The blockchain network
/// @param contractAddress The contract address on the specified chain
/// @return A ChainIdContract with full block range coverage
function chainContract(Chains chain, address contractAddress) pure returns (ChainIdContract memory) {
    return ChainIdContract({
        chainId: chainToChainId(chain),
        contractAddress: contractAddress,
        blockRange: blockRangeFull()
    });
}

/// @notice Creates a ChainIdContract from a ChainWithRange and contract address
/// @param chain The chain configuration with block range
/// @param contractAddress The contract address on the specified chain
/// @return A ChainIdContract with the inherited block range
function chainContract(ChainWithRange memory chain, address contractAddress) pure returns (ChainIdContract memory) {
    return ChainIdContract({chainId: chain.chainId, contractAddress: contractAddress, blockRange: chain.blockRange});
}

/// @notice Represents an Application Binary Interface definition
/// @dev Simple container for ABI identification
struct Abi {
    /// @notice The name of the ABI (e.g., "ERC20", "UniswapV3Pool")
    string name;
}

/// @notice Represents a trigger target for contracts matching an ABI
/// @dev Used for targeting multiple contracts that implement the same ABI
struct AbiTarget {
    /// @notice The target ABI and chain information
    ChainIdAbi targetAbi;
    /// @notice The trigger configuration
    Trigger trigger;
    /// @notice Selector of the handler function (duplicated for efficiency)
    bytes32 handlerSelector;
    /// @notice Code hash of the listener contract (duplicated for efficiency)
    bytes32 listenerCodehash;
    /// @notice Block range for this trigger target
    BlockRange blockRange;
}

/// @notice Represents an ABI configuration for a specific blockchain
/// @dev Combines chain ID, ABI definition, and block range
struct ChainIdAbi {
    /// @notice The EIP-155 chain ID
    uint256 chainId;
    /// @notice The ABI definition
    Abi abi;
    /// @notice The block range for monitoring contracts with this ABI
    BlockRange blockRange;
}

/// @notice Creates a ChainIdAbi for a specific chain and ABI
/// @param chain The blockchain network
/// @param abiData The ABI definition
/// @return A ChainIdAbi with full block range coverage
function chainAbi(Chains chain, Abi memory abiData) pure returns (ChainIdAbi memory) {
    return ChainIdAbi({chainId: chainToChainId(chain), abi: abiData, blockRange: blockRangeFull()});
}

/// @notice Creates a ChainIdAbi from a ChainWithRange and ABI
/// @param chain The chain configuration with block range
/// @param abiData The ABI definition
/// @return A ChainIdAbi with the inherited block range
function chainAbi(ChainWithRange memory chain, Abi memory abiData) pure returns (ChainIdAbi memory) {
    return ChainIdAbi({chainId: chain.chainId, abi: abiData, blockRange: chain.blockRange});
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

/// @notice Represents a global trigger configuration for a specific blockchain
/// @dev Used for chain-wide triggers that don't target specific contracts or ABIs
struct ChainIdGlobal {
    /// @notice The EIP-155 chain ID
    uint256 chainId;
    /// @notice The block range for this global configuration
    BlockRange blockRange;
}

/// @notice Creates a ChainIdGlobal for a specific chain
/// @param chain The blockchain network
/// @return A ChainIdGlobal with full block range coverage
function chainGlobal(Chains chain) pure returns (ChainIdGlobal memory) {
    return ChainIdGlobal({chainId: chainToChainId(chain), blockRange: blockRangeFull()});
}

/// @notice Creates a ChainIdGlobal from a ChainWithRange
/// @param chain The chain configuration with block range
/// @return A ChainIdGlobal with the inherited block range
function chainGlobal(ChainWithRange memory chain) pure returns (ChainIdGlobal memory) {
    return ChainIdGlobal({chainId: chain.chainId, blockRange: chain.blockRange});
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

/// @notice Represents a global trigger target for chain-wide monitoring
/// @dev Used for raw triggers that monitor entire chains rather than specific contracts
struct GlobalTarget {
    /// @notice The EIP-155 chain ID to monitor
    uint256 chainId;
    /// @notice The type of raw trigger
    RawTriggerType triggerType;
    /// @notice Selector of the handler function to call
    bytes32 handlerSelector;
    /// @notice Code hash of the listener contract
    bytes32 listenerCodehash;
    /// @notice Block range for this global trigger
    BlockRange blockRange;
}

/// @title Base Triggers Contract
/// @notice Abstract base contract for managing blockchain event triggers
/// @dev Provides the foundation for trigger registration and management across different target types
abstract contract BaseTriggers {
    /// @dev Array of contract-specific trigger targets
    ContractTarget[] _contractTargets;
    /// @dev Array of ABI-based trigger targets
    AbiTarget[] _abiTargets;
    /// @dev Array of global/chain-wide trigger targets
    GlobalTarget[] _globalTargets;

    /// @notice Abstract function that must be implemented to configure triggers
    /// @dev Called during trigger setup to register all desired triggers
    function triggers() external virtual;

    /// @notice Adds a trigger for a specific contract
    /// @param targetContract The contract to monitor
    /// @param triggerFunction The trigger configuration
    /// @dev Inherits the block range from the target contract
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

    /// @notice Adds multiple triggers for a specific contract
    /// @param targetContract The contract to monitor
    /// @param triggers_ Array of trigger configurations
    /// @dev Convenience function to add multiple triggers for the same contract
    function addTriggers(ChainIdContract memory targetContract, Trigger[] memory triggers_) internal {
        for (uint256 i = 0; i < triggers_.length; i++) {
            addTrigger(targetContract, triggers_[i]);
        }
    }

    /// @notice Adds a trigger for contracts matching a specific ABI
    /// @param targetAbi The ABI configuration to monitor
    /// @param triggerFunction The trigger configuration
    /// @dev Inherits the block range from the target ABI configuration
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

    /// @notice Adds multiple triggers for contracts matching a specific ABI
    /// @param targetAbi The ABI configuration to monitor
    /// @param triggers_ Array of trigger configurations
    /// @dev Convenience function to add multiple triggers for the same ABI
    function addTriggers(ChainIdAbi memory targetAbi, Trigger[] memory triggers_) internal {
        for (uint256 i = 0; i < triggers_.length; i++) {
            addTrigger(targetAbi, triggers_[i]);
        }
    }

    /// @notice Adds a global trigger for chain-wide monitoring
    /// @param chain The chain configuration to monitor
    /// @param trigger The raw trigger configuration
    /// @dev Used for monitoring entire chains rather than specific contracts
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

    /// @notice Adds multiple global triggers for chain-wide monitoring
    /// @param chainId The chain configuration to monitor
    /// @param triggers_ Array of raw trigger configurations
    /// @dev Convenience function to add multiple global triggers for the same chain
    function addTriggers(ChainIdGlobal memory chainId, RawTrigger[] memory triggers_) internal {
        for (uint256 i = 0; i < triggers_.length; i++) {
            addTrigger(chainId, triggers_[i]);
        }
    }

    /// @notice Returns all configured trigger targets
    /// @return abiTargets Array of ABI-based trigger targets
    /// @return contractTargets Array of contract-specific trigger targets
    /// @return globalTargets Array of global trigger targets
    /// @dev Used by the indexing system to retrieve all configured triggers
    function getSimTargets()
        external
        view
        returns (AbiTarget[] memory, ContractTarget[] memory, GlobalTarget[] memory)
    {
        return (_abiTargets, _contractTargets, _globalTargets);
    }
}
