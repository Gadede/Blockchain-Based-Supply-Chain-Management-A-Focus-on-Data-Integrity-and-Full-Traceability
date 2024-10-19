/* eslint-disable quotes */
// This file holds contracts ABI, Address and Default Gas for contract execution.

var ABI = [
  {
    constant: true,
    inputs: [
      {
        internalType: "bytes32",
        name: "_messageHash",
        type: "bytes32"
      }
    ],
    name: "getEthSignedMessageHash",
    outputs: [
      {
        internalType: "bytes32",
        name: "",
        type: "bytes32"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  }
]

var contractAddress = '0xe5f7ed2A3Aa9bbceB0a78630395d797Cd46E18a8'

var suppliedGas = 3000000

export { ABI, contractAddress, suppliedGas }
