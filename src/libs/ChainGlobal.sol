// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./BlockRange.sol";

using ChainGlobalLibrary for ChainIdGlobal global;

/// @notice Represents a global trigger configuration for a specific blockchain
/// @dev Used for chain-wide triggers that don't target specific contracts or ABIs
struct ChainIdGlobal {
    /// @notice The EIP-155 chain ID
    uint256 chainId;
    /// @notice The block range for this global configuration
    BlockRange blockRange;
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
