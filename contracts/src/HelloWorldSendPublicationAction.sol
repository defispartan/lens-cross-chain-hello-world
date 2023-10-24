// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {HubRestricted} from 'lens/HubRestricted.sol';
import {Types} from 'lens/Types.sol';
import {IPublicationActionModule} from './interfaces/IPublicationActionModule.sol';
import  "layerzero/lzApp/NonblockingLzApp.sol";

contract HelloWorldSendPublicationAction is HubRestricted, IPublicationActionModule, NonblockingLzApp {
    mapping(uint256 profileId => mapping(uint256 pubId => string initMessage)) internal _initMessages;
    uint16 public destChainId = 10161; // Sepolia
    
    constructor() HubRestricted(0xC1E77eE73403B8a7478884915aA599932A677870) NonblockingLzApp(0xf69186dfBa60DdB133E91E9A4B5673624293d8F8) {} // Lens V2 Mumbai Hub Proxy and LayerZero Mumbai endpoint

    function initializePublicationAction(
        uint256 profileId,
        uint256 pubId,
        address /* transactionExecutor */,
        bytes calldata data
    ) external override onlyHub returns (bytes memory) {
        string memory initMessage = abi.decode(data, (string));

        _initMessages[profileId][pubId] = initMessage;

        return data;
    }

    function processPublicationAction(
        Types.ProcessActionParams calldata params
    ) external override onlyHub returns (bytes memory) {
        string memory initMessage = _initMessages[params.publicationActedProfileId][params.publicationActedId];
        (address target, string memory actionMessage, uint nativeFee) = abi.decode(params.actionModuleData, (address, string, uint));
        bytes memory payload = abi.encode(target, initMessage, actionMessage);
        _lzSend(destChainId, payload, payable(msg.sender), address(0x0), bytes(""), nativeFee);
        return abi.encode(actionMessage, initMessage);
    }

    function _nonblockingLzReceive(
        uint16 /*_srcChainId*/,
        bytes memory /*_srcAddress*/,
        uint64, /*_nonce*/
        bytes memory /*_payload*/
    ) internal override {
    }

    receive() external payable {}
}