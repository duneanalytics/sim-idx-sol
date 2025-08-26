// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./BlockRange.sol";

using ChainsLib for Chains global;
using ChainsLib for ChainWithRange global;

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
