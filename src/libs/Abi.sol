// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./BlockRange.sol";

using AbiLibrary for ChainIdAbi global;

/// @notice Represents an Application Binary Interface definition
/// @dev Simple container for ABI identification
struct Abi {
    /// @notice The name of the ABI (e.g., "ERC20", "UniswapV3Pool")
    string name;
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
