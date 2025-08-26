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

using BlockRangeLib for BlockRange global;

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
