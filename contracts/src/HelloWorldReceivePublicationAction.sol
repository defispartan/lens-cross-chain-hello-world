// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {IHelloWorld} from './interfaces/IHelloWorld.sol';
import "layerzero/lzApp/NonblockingLzApp.sol";

contract HelloWorldReceivePublicationAction is NonblockingLzApp {

    constructor() NonblockingLzApp(0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1) {} // LayerZero Sepolia endpoint


    function _nonblockingLzReceive(
        uint16 /* srcChainId */,
        bytes memory /* srcAddress */,
        uint64 /* _nonce */,
        bytes memory _payload
    ) internal virtual override {
        (address target, string memory initMessage, string memory actionMessage) = abi.decode(_payload, (address, string, string));

        string memory combinedMessage = string(abi.encodePacked(initMessage, " ", actionMessage));

        IHelloWorld(target).helloWorld(combinedMessage);
    }
}