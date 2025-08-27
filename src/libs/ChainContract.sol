// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./BlockRange.sol";

using ChainContractLibrary for ChainIdContract global;

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
