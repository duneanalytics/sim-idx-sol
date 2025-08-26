// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Chains.sol";

using NativeTokenLib for NativeToken global;

struct NativeToken {
    string name;
    string symbol;
    uint8 decimals;
}

library NativeTokenLib {
    /// @notice Creates a native token for a given chain ID
    /// @param chainId The EIP-155 chain ID
    /// @return The native token for the given chain ID
    /// @dev Reverts with "Unsupported chain" for unknown chain IDs
    function withChainId(uint256 chainId) internal pure returns (NativeToken memory) {
        if (chainId == chainToChainId(Chains.Ethereum)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.EthereumSepolia)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.Base)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.BaseSepolia)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.WorldChain)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.Mode)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.Ink)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.Unichain)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.Zora)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.BOB)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.Soneium)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.Shape)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.Arbitrum)) return NativeToken("Ether", "ETH", 18);
        if (chainId == chainToChainId(Chains.Optimism)) return NativeToken("Ether", "ETH", 18);
        revert("Unsupported chain");
    }
}
