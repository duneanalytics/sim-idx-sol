// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {Chains, chainToChainId} from "./Triggers.sol";

interface ArbSys {
    /**
     * @notice Get Arbitrum block number (distinct from L1 block number; Arbitrum genesis block has block number 0)
     * @return block number as int
     */
    function arbBlockNumber() external view returns (uint256);
}

ArbSys constant ARB_SYS_ADDRESS = ArbSys(0x0000000000000000000000000000000000000064);

function blockNumber() view returns (uint64) {
    if (block.chainid == chainToChainId(Chains.Arbitrum)) return uint64(ARB_SYS_ADDRESS.arbBlockNumber());
    return uint64(block.number);
}
