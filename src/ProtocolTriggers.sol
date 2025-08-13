// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Triggers.sol";
import {ChainsEnumerableMapLib} from "./utils/ChainsEnumerableMapLib.sol";

struct ProtocolConfigAddress {
    Trigger[] triggers;
    ChainsEnumerableMapLib.ChainsToChainIdContractMap chainIdToAddressEnumerable;
}

struct ProtocolConfigAbi {
    Trigger[] triggers;
    ChainsEnumerableMapLib.ChainsToChainIdAbiMap chainIdToAbiEnumerable;
}

abstract contract ProtocolTriggers is BaseTriggers {
    using ChainsEnumerableMapLib for ChainsEnumerableMapLib.ChainsToChainIdContractMap;
    using ChainsEnumerableMapLib for ChainsEnumerableMapLib.ChainsToChainIdAbiMap;

    function addTriggerForProtocol(ProtocolConfigAbi storage config) internal {
        for (uint256 i = 0; i < config.chainIdToAbiEnumerable.length(); i++) {
            (, ChainIdAbi memory _abi) = config.chainIdToAbiEnumerable.getAtIndex(i);
            addTriggers(_abi, config.triggers);
        }
    }

    function addTriggerForProtocol(ProtocolConfigAddress storage config) internal {
        for (uint256 i = 0; i < config.chainIdToAddressEnumerable.length(); i++) {
            (, ChainIdContract memory _contract) = config.chainIdToAddressEnumerable.getAtIndex(i);
            addTriggers(_contract, config.triggers);
        }
    }
}
