import ethers from "ethers";
import { abi } from './lensHubAbi';

// the trusted remote (or sometimes referred to as the path or pathData)
// is the packed 40 bytes object of the REMOTE + LOCAL user application contract addresses

const remoteAddress = "0x31c94b3996B5E94DA7B72633D73b90a196f02e69" // mumbai send contract
const localAddress = "0xD88D282f1A3eB7C3d647E1af6812043053e4dDaB" // sepolia receive contract

const trustedRemotePathReceiver = ethers.utils.solidityPack(
    ['address', 'address'],
    [remoteAddress, localAddress]
);

console.log(trustedRemotePathReceiver);