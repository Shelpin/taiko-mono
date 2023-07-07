// SPDX-License-Identifier: MIT
//  _____     _ _         _         _
// |_   _|_ _(_) |_____  | |   __ _| |__ ___
//   | |/ _` | | / / _ \ | |__/ _` | '_ (_-<
//   |_|\__,_|_|_\_\___/ |____\__,_|_.__/__/

pragma solidity ^0.8.20;

import { AddressResolver } from "../../../common/AddressResolver.sol";
import { BlockHeader } from "../../../libs/LibBlockHeader.sol";
import { IErc721Bridge } from "../IErc721Bridge.sol";
import { LibAddress } from "../../../libs/LibAddress.sol";

/**
 * Stores message metadata on the Bridge. It's used to keep track of the state
 * of messages that are being
 * transferred across the bridge, and it contains functions to hash messages and
 * check their status.
 */
library LibErc721BridgeData {
    /// @dev The State struct stores the state of messages in the Bridge
    /// contract.
    struct State {
        uint256 nextMessageId;
        IErc721Bridge.Context ctx; // 3 slots
        mapping(bytes32 msgHash => bool released) tokensReleased;
        uint256[45] __gap;
    }

    /// @dev StatusProof holds the block header and proof for a particular
    /// status.
    struct StatusProof {
        BlockHeader header;
        bytes proof;
    }

    bytes32 internal constant MESSAGE_HASH_PLACEHOLDER = bytes32(uint256(1));
    uint256 internal constant CHAINID_PLACEHOLDER = type(uint256).max;
    address internal constant SRC_CHAIN_SENDER_PLACEHOLDER =
        address(uint160(uint256(1)));

    // Note: These events must match the ones defined in Bridge.sol.
    event MessageSentErc721(bytes32 indexed msgHash, IErc721Bridge.Message message);
    event DestChainEnabledErc721(uint256 indexed chainId, bool enabled);

    /**
     * Calculate the keccak256 hash of the message
     * @param message The message to be hashed
     * @return msgHash The keccak256 hash of the message
     */
    function hashMessage(IErc721Bridge.Message memory message)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(message));
    }
}