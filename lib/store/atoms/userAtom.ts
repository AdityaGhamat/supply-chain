import { atom } from "recoil";

const userAtom = atom({
  key: "userAccount",
  default: {
    address: null,
    balance: null,
    network: null,
    isConnected: false,
  },
});
export default userAtom;
