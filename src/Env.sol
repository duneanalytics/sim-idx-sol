// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

/// @title Environment Utilities
/// @notice Provides cross-chain compatible environment functions
/// @dev Handles chain-specific implementations for block number retrieval

import {Chains, chainToChainId} from "./Triggers.sol";

/// @notice Interface for Arbitrum's system contract
/// @dev Provides access to Arbitrum-specific system functions
interface ArbSys {
    /// @notice Get Arbitrum block number (distinct from L1 block number; Arbitrum genesis block has block number 0)
    /// @return block number as uint256
    function arbBlockNumber() external view returns (uint256);
}

/// @dev Address of the Arbitrum system contract - precompiled contract available on all Arbitrum chains
ArbSys constant ARB_SYS_ADDRESS = ArbSys(0x0000000000000000000000000000000000000064);

/// @notice Returns the current block number for any supported chain
/// @dev Handles chain-specific block number retrieval, particularly for Arbitrum
/// @return Current block number as uint64
/// @custom:arbitrum On Arbitrum chains, uses the ArbSys precompile to get the L2 block number
/// @custom:ethereum On Ethereum and other chains, uses the standard block.number
function blockNumber() view returns (uint64) {
    if (block.chainid == chainToChainId(Chains.Arbitrum)) return uint64(ARB_SYS_ADDRESS.arbBlockNumber());
    return uint64(block.number);
}
