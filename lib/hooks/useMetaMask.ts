import { useRecoilState } from "recoil";
import userAtom from "../store/atoms/userAtom";
import { ethers } from "ethers";

function useMetaMask() {
  const [user, setUser] = useRecoilState(userAtom);
  const connectMetaMask = async () => {
    if (window.ethereum) {
      try {
        const accounts = await window.ethereum.request({
          method: "eth_requestAccounts",
        });
        setUser({
          ...user,
          address: accounts[0],
          isConnected: true,
        });
      } catch (error) {
        console.error("Failed to connect to metamask wallet", error);
      }
    } else {
      console.log("MetaMask is not detected.");
    }
    return { connectMetaMask };
  };
}
export default useMetaMask;
