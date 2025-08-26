// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

///  @notice Returns an address only if it has code
///  @param a The address to check
///  @return result The address if it has code, otherwise address(0)
function safeReturnAddress(address a) view returns (address result) {
    return isContract(a) ? a : address(0);
}

///  @notice Returns whether an address is a contract.
///  @param a The address to check
///  @return true if the address is a contract, otherwise false.
function isContract(address a) view returns (bool) {
    uint32 size;
    assembly {
        size := extcodesize(a)
    }
    return (size > 0);
}
