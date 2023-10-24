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

  const encodedInitData = ethers.utils.defaultAbiCoder.encode(['string'], ['This is my test initialize']);

  // Post parameters
  const params = {
    profileId: 387,
    contentURI:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWKz_uDp9UZavfEuJSQGplBK2BQ4Vp5ScqrpusLDDtvg&s",
    actionModules: ["0x31c94b3996b5e94da7b72633d73b90a196f02e69"],
    actionModulesInitDatas: [
      encodedInitData
    ],
    referenceModule: "0x0000000000000000000000000000000000000000",
    referenceModuleInitData: ethers.utils.arrayify("0x01"),
  };

  const calldata = contract.interface.encodeFunctionData("post", [params]);
  //console.log(encodedInitData)
  console.log(calldata);
};

main().catch(console.error);
