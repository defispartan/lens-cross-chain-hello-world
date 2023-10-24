# Lens Open Action Cross-Chain Hello World

Call `helloWorld` through a Lens Open Action, with a message related between Mumbai and Sepolia using LayerZero

Steps:
1.) `cp .env.example .env` and input deployment values
2.) Deploy `HelloWorldSendPublicationAction.sol` on Mumbai: `forge script script/HelloWorldMumbai.s.sol:HelloWorldMumbaiScript --rpc-url $MUMBAI_RPC_URL --broadcast --verify -vvvv`
3.) Deploy `HelloWorldReceivePublicationAction.sol` and `HellowWorld.sol` on Sepolia: `forge script script/HelloWorldSepolia.s.sol:HelloWorldSepoliaScript --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv`
4.) Call `post` on the [LensHub V2 Mumbai Proxy](https://mumbai.polygonscan.com/address/0xC1E77eE73403B8a7478884915aA599932A677870) which will call `initializePublicationAction` on `HelloWorldSendPublicationAction.sol`. To encode txn calldata, there is a helper script which you can then manually submit to the Lens Hub contract: `bun install && bun run encodeInitPost.ts`
5.) Call `setTrustedRemote` on both the sender and receiver contracts, following the [LayerZero docs](https://layerzero.gitbook.io/docs/evm-guides/master/set-trusted-remotes). Be sure to use chainID from [LZ docs](https://layerzero.gitbook.io/docs/technical-reference/testnet/testnet-addresses) which is not same as network chainID
5.) Call `act` on the `LensHub` Mumbai address with the publicationID from step 4, with data field encoded as `(address target, string memory actionMessage, uint nativeFee) = abi.decode(params.actionModuleData, (address, string, uint));` where target is the address of the `HelloWorld.sol` contract, `actionMessage` is a string which will also be output on destination chain, and `nativeFee` is the maximum gas fee to be paid on Mumbai.

After calling, LayerZero should execute the lzReceive automatically and there should be an event emitted from `HelloWorld.sol` with the init and action messages.

Verified Deployments:
`HelloWorldSendPublicationAction`: https://mumbai.polygonscan.com/address/0x31c94b3996B5E94DA7B72633D73b90a196f02e69
`HelloWorldReceivePublicationAction`: https://sepolia.etherscan.io/address/0xD88D282f1A3eB7C3d647E1af6812043053e4dDaB
`HelloWorld`: https://sepolia.etherscan.io/address/0xCC96F270885B7DfFb405841e2b0b189A8Ffc733b

## Status

The Lens portion of the action is complete, the action module is able to be intialized and executed.

The call to `act` is currently reverting inside of `lzSend`, [txn trace](https://dashboard.tenderly.co/tx/polygon-mumbai/0x689016d1b7ebfdabc6b3a2963bb52cec40aa63fe015cf405dba62ba636b61146). The default [LayerZero send library](https://mumbai.polygonscan.com/address/0xf69186dfba60ddb133e91e9a4b5673624293d8f8#readContract#F6) on Mumbai is unverified so it's difficult to debug but it's likely an issue with the gas configuration.
