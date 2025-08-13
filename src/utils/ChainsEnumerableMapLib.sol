// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {EnumerableMapLib} from "./EnumerableMapLib.sol";
import {Chains, ChainIdContract, ChainIdAbi} from "../Triggers.sol";

/// @notice Library for managing enumerable maps with Chains enum keys.
/// @dev Provides convenient wrappers around EnumerableMapLib for Chains enum mappings.
///
/// @dev Benefits over regular mappings:
/// 1. **Iteration Support**: Unlike regular mappings, you can iterate over all keys and values
/// 2. **Key Enumeration**: Get all keys that have been set with `keys()` function
/// 3. **Length Tracking**: Know how many entries exist with `length()` function
/// 4. **Existence Checking**: Reliable `contains()` to check if a key exists
/// 5. **Index Access**: Access entries by index with `getIndexAt()` function
/// 6. **Gas Efficient**: Optimized for small to medium sized collections
///
/// @dev Usage Examples:
/// ```solidity
/// // Declare the map
/// ChainsEnumerableMapLib.ChainsToChainIdContractMap private contracts;
/// using ChainsEnumerableMapLib for ChainsEnumerableMapLib.ChainsToChainIdContractMap;
///
/// // Add entries
/// contracts.set(Chains.Ethereum, chainContract(Chains.Ethereum, 0x123...));
/// contracts.set(Chains.Base, chainContract(Chains.Base, 0x456...));
///
/// // Check existence
/// bool hasEthereumContract = contracts.contains(Chains.Ethereum);
///
/// // Get all configured chains
/// Chains[] memory allChains = contracts.keys();
///
/// // Iterate over all entries
/// for (uint256 i = 0; i < contracts.length(); i++) {
///     (Chains chain, ChainIdContract memory contract_) = contracts.getAtIndex(i);
///     // Process each entry...
/// }
///
/// // Remove entries
/// contracts.remove(Chains.Ethereum);
/// ```
library ChainsEnumerableMapLib {
    /// @dev An enumerable map of `Chains` to `ChainIdContract`.
    struct ChainsToChainIdContractMap {
        EnumerableMapLib.Uint8ToChainIdContractMap _inner;
    }

    /// @dev An enumerable map of `Chains` to `ChainIdAbi`.
    struct ChainsToChainIdAbiMap {
        EnumerableMapLib.Uint8ToChainIdAbiMap _inner;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*               CHAINS TO CHAINIDCONTRACT MAP               */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Adds a key-value pair to the map, or updates the value for an existing key.
    /// Returns true if `key` was added to the map, that is if it was not already present.
    function set(ChainsToChainIdContractMap storage map, Chains key, ChainIdContract memory value)
        internal
        returns (bool)
    {
        return EnumerableMapLib.set(map._inner, uint8(key), value);
    }

    /// @dev Adds a key-value pair to the map, or updates the value for an existing key.
    /// Returns true if `key` was added to the map, that is if it was not already present.
    /// Reverts if the map grows bigger than the custom on-the-fly capacity `cap`.
    function set(ChainsToChainIdContractMap storage map, Chains key, ChainIdContract memory value, uint256 cap)
        internal
        returns (bool)
    {
        return EnumerableMapLib.set(map._inner, uint8(key), value, cap);
    }

    /// @dev Removes a key-value pair from the map.
    /// Returns true if `key` was removed from the map, that is if it was present.
    function remove(ChainsToChainIdContractMap storage map, Chains key) internal returns (bool) {
        return EnumerableMapLib.remove(map._inner, uint8(key));
    }

    /// @dev Shorthand for `isAdd ? map.set(key, value, cap) : map.remove(key)`.
    function update(
        ChainsToChainIdContractMap storage map,
        Chains key,
        ChainIdContract memory value,
        bool isAdd,
        uint256 cap
    ) internal returns (bool) {
        return isAdd ? set(map, key, value, cap) : remove(map, key);
    }

    /// @dev Returns true if the key is in the map.
    function contains(ChainsToChainIdContractMap storage map, Chains key) internal view returns (bool) {
        return EnumerableMapLib.contains(map._inner, uint8(key));
    }

    /// @dev Returns the number of key-value pairs in the map.
    function length(ChainsToChainIdContractMap storage map) internal view returns (uint256) {
        return EnumerableMapLib.length(map._inner);
    }

    /// @dev Returns the key-value pair at index `i`. Reverts if `i` is out-of-bounds.
    function getAtIndex(ChainsToChainIdContractMap storage map, uint256 i)
        internal
        view
        returns (Chains key, ChainIdContract memory value)
    {
        (uint8 rawKey, ChainIdContract memory val) = EnumerableMapLib.getIndexAt(map._inner, i);
        return (Chains(rawKey), val);
    }

    /// @dev Tries to return the value associated with the key.
    function tryGet(ChainsToChainIdContractMap storage map, Chains key)
        internal
        view
        returns (bool exists, ChainIdContract memory value)
    {
        return EnumerableMapLib.tryGet(map._inner, uint8(key));
    }

    /// @dev Returns the value for the key. Reverts if the key is not found.
    function get(ChainsToChainIdContractMap storage map, Chains key)
        internal
        view
        returns (ChainIdContract memory value)
    {
        return EnumerableMapLib.get(map._inner, uint8(key));
    }

    /// @dev Returns the keys as Chains enum values. May run out-of-gas if the map is too big.
    function keys(ChainsToChainIdContractMap storage map) internal view returns (Chains[] memory result) {
        uint8[] memory rawKeys = EnumerableMapLib.keys(map._inner);
        result = new Chains[](rawKeys.length);
        for (uint256 i = 0; i < rawKeys.length; i++) {
            result[i] = Chains(rawKeys[i]);
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                 CHAINS TO CHAINIDABI MAP                  */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Adds a key-value pair to the map, or updates the value for an existing key.
    /// Returns true if `key` was added to the map, that is if it was not already present.
    function set(ChainsToChainIdAbiMap storage map, Chains key, ChainIdAbi memory value) internal returns (bool) {
        return EnumerableMapLib.set(map._inner, uint8(key), value);
    }

    /// @dev Adds a key-value pair to the map, or updates the value for an existing key.
    /// Returns true if `key` was added to the map, that is if it was not already present.
    /// Reverts if the map grows bigger than the custom on-the-fly capacity `cap`.
    function set(ChainsToChainIdAbiMap storage map, Chains key, ChainIdAbi memory value, uint256 cap)
        internal
        returns (bool)
    {
        return EnumerableMapLib.set(map._inner, uint8(key), value, cap);
    }

    /// @dev Removes a key-value pair from the map.
    /// Returns true if `key` was removed from the map, that is if it was present.
    function remove(ChainsToChainIdAbiMap storage map, Chains key) internal returns (bool) {
        return EnumerableMapLib.remove(map._inner, uint8(key));
    }

    /// @dev Shorthand for `isAdd ? map.set(key, value, cap) : map.remove(key)`.
    function update(ChainsToChainIdAbiMap storage map, Chains key, ChainIdAbi memory value, bool isAdd, uint256 cap)
        internal
        returns (bool)
    {
        return isAdd ? set(map, key, value, cap) : remove(map, key);
    }

    /// @dev Returns true if the key is in the map.
    function contains(ChainsToChainIdAbiMap storage map, Chains key) internal view returns (bool) {
        return EnumerableMapLib.contains(map._inner, uint8(key));
    }

    /// @dev Returns the number of key-value pairs in the map.
    function length(ChainsToChainIdAbiMap storage map) internal view returns (uint256) {
        return EnumerableMapLib.length(map._inner);
    }

    /// @dev Returns the key-value pair at index `i`. Reverts if `i` is out-of-bounds.
    function getAtIndex(ChainsToChainIdAbiMap storage map, uint256 i)
        internal
        view
        returns (Chains key, ChainIdAbi memory value)
    {
        (uint8 rawKey, ChainIdAbi memory val) = EnumerableMapLib.getIndexAt(map._inner, i);
        return (Chains(rawKey), val);
    }

    /// @dev Tries to return the value associated with the key.
    function tryGet(ChainsToChainIdAbiMap storage map, Chains key)
        internal
        view
        returns (bool exists, ChainIdAbi memory value)
    {
        return EnumerableMapLib.tryGet(map._inner, uint8(key));
    }

    /// @dev Returns the value for the key. Reverts if the key is not found.
    function get(ChainsToChainIdAbiMap storage map, Chains key) internal view returns (ChainIdAbi memory value) {
        return EnumerableMapLib.get(map._inner, uint8(key));
    }

    /// @dev Returns the keys as Chains enum values. May run out-of-gas if the map is too big.
    function keys(ChainsToChainIdAbiMap storage map) internal view returns (Chains[] memory result) {
        uint8[] memory rawKeys = EnumerableMapLib.keys(map._inner);
        result = new Chains[](rawKeys.length);
        for (uint256 i = 0; i < rawKeys.length; i++) {
            result[i] = Chains(rawKeys[i]);
        }
    }
}
