import tracking from "../../artifacts/contracts/Tracking.sol/Tracking.json";
import { ContractRunner, ethers } from "ethers";

const contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3";

const contractAbi = tracking.abi;

export const fetchContract = (signerProvider: ContractRunner) =>
  new ethers.Contract(contractAddress, contractAbi, signerProvider);
