import ethers from "ethers";
import { abi } from './lensHubAbi';


// script to help encode parameters for post() call

const lensHubProxyAddress = "0xC1E77eE73403B8a7478884915aA599932A677870";

const main = async () => {
    const contract = new ethers.Contract(
        lensHubProxyAddress,
        abi,
        new ethers.VoidSigner(lensHubProxyAddress)
    );
    const nativeFee = ethers.BigNumber.from("500000000000000000"); // 0.5 Matic max
    const encodedActionData = ethers.utils.defaultAbiCoder.encode(['address', 'string', 'uint'], ["0xCC96F270885B7DfFb405841e2b0b189A8Ffc733b", "This is my action message", nativeFee]);

    // Act parameters
    const params = {
        publicationActedProfileId: 387,
        publicationActedId: 1,
        actorProfileId: 387,
        referrerProfileIds: [],
        referrerPubIds: [],
        actionModuleAddress: "0x31c94b3996B5E94DA7B72633D73b90a196f02e69",
        actionModuleData: encodedActionData,
    };
    const calldata = contract.interface.encodeFunctionData("act", [params]);
    //console.log(encodedActionData)
    console.log(calldata);
};

main().catch(console.error);
