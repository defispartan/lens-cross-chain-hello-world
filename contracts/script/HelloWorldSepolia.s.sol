// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {HelloWorldReceivePublicationAction} from "src/HelloWorldReceivePublicationAction.sol";
import {HelloWorld} from "src/HelloWorld.sol";

contract HelloWorldSepoliaScript is Script {
    function setUp() public {}

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new HelloWorld();
        new HelloWorldReceivePublicationAction();

        vm.stopBroadcast();
    }
}
