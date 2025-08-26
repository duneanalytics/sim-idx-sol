// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @title Protocol Trigger Management
/// @notice Provides high-level protocol configuration for multi-chain trigger management
/// @dev Extends BaseTriggers with protocol-specific configuration utilities

import "./Triggers.sol";
import {ChainsEnumerableMapLib} from "./utils/ChainsEnumerableMapLib.sol";

/// @notice Configuration for address-based protocol triggers
/// @dev Stores triggers and their corresponding contract addresses across multiple chains
struct ProtocolConfigAddress {
    /// @notice Array of triggers to apply to all configured contracts
    Trigger[] triggers;
    /// @notice Enumerable map of chains to contract addresses
    ChainsEnumerableMapLib.ChainsToChainIdContractMap chainIdToAddressEnumerable;
}

/// @notice Configuration for ABI-based protocol triggers
/// @dev Stores triggers and their corresponding ABI configurations across multiple chains
struct ProtocolConfigAbi {
    /// @notice Array of triggers to apply to all contracts matching the ABI
    Trigger[] triggers;
    /// @notice Enumerable map of chains to ABI configurations
    ChainsEnumerableMapLib.ChainsToChainIdAbiMap chainIdToAbiEnumerable;
}

/// @title Protocol Triggers Contract
/// @notice Abstract contract for managing protocol-level trigger configurations
/// @dev Provides utilities for configuring triggers across multiple chains for a protocol
abstract contract ProtocolTriggers is BaseTriggers {
    using ChainsEnumerableMapLib for ChainsEnumerableMapLib.ChainsToChainIdContractMap;
    using ChainsEnumerableMapLib for ChainsEnumerableMapLib.ChainsToChainIdAbiMap;

    /// @notice Adds triggers for all ABIs in an ABI-based protocol configuration
    /// @param config The protocol configuration containing ABIs and triggers
    /// @dev Iterates through all configured ABIs and applies all triggers to each
    function addTriggerForProtocol(ProtocolConfigAbi storage config) internal {
        for (uint256 i = 0; i < config.chainIdToAbiEnumerable.length(); i++) {
            (, ChainIdAbi memory _abi) = config.chainIdToAbiEnumerable.getAtIndex(i);
            addTriggers(_abi, config.triggers);
        }
    }

    /// @notice Adds triggers for all contracts in an address-based protocol configuration
    /// @param config The protocol configuration containing contracts and triggers
    /// @dev Iterates through all configured contracts and applies all triggers to each
    function addTriggerForProtocol(ProtocolConfigAddress storage config) internal {
        for (uint256 i = 0; i < config.chainIdToAddressEnumerable.length(); i++) {
            (, ChainIdContract memory _contract) = config.chainIdToAddressEnumerable.getAtIndex(i);
            addTriggers(_contract, config.triggers);
        }
    }
}
