/// @notice Library for working with global index values (uint120)
/// @dev Layout of global index:
/// - blockNumber (32 bits)
/// - reorgIncarnation (24 bits)
/// - txnIndex (24 bits)
/// - shadowPc (40 bits)
library GlobalIndexLib {
    /// @notice Extracts the block number from a global index
    /// @param index The global index value
    /// @return The block number component (32 bits)
    function getBlockNumber(uint120 index) internal pure returns (uint32) {
        return uint32(index >> 88);
    }

    /// @notice Extracts the reorg incarnation from a global index
    /// @param index The global index value
    /// @return The reorg incarnation component (24 bits)
    function getReorgIncarnation(uint120 index) internal pure returns (uint24) {
        return uint24((index >> 64));
    }

    /// @notice Extracts the transaction index from a global index
    /// @param index The global index value
    /// @return The transaction index component (24 bits)
    function getTxnIndex(uint120 index) internal pure returns (uint24) {
        return uint24((index >> 40));
    }

    /// @notice Extracts the shadow program counter from a global index
    /// @param index The global index value
    /// @return The shadow program counter component (40 bits)
    function getShadowPc(uint120 index) internal pure returns (uint40) {
        return uint40(index);
    }
}
