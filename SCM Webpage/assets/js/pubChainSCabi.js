/* eslint-disable quotes */
// This file holds contracts ABI, Address and Default Gas for contract execution.

var ABI = [
  {
    constant: false,
    inputs: [
      {
        internalType: "string",
        name: "productID",
        type: "string"
      }
    ],
    name: "assetTransfer_retailer",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool"
      }
    ],
    payable: true,
    stateMutability: "payable",
    type: "function"
  },
  {
    constant: false,
    inputs: [
      {
        internalType: "string",
        name: "productID",
        type: "string"
      },
      {
        internalType: "address",
        name: "retailer",
        type: "address"
      }
    ],
    name: "assetTransfer_wholseller",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool"
      }
    ],
    payable: true,
    stateMutability: "payable",
    type: "function"
  },
  {
    constant: false,
    inputs: [
      {
        internalType: "address payable",
        name: "farmer_Address",
        type: "address"
      },
      {
        internalType: "string",
        name: "productID",
        type: "string"
      },
      {
        internalType: "string",
        name: "shippingAddress",
        type: "string"
      },
      {
        internalType: "address payable",
        name: "wholeseller",
        type: "address"
      }
    ],
    name: "Buy_Farmer_Product",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string"
      }
    ],
    payable: true,
    stateMutability: "payable",
    type: "function"
  },
  {
    constant: false,
    inputs: [
      {
        internalType: "address",
        name: "requester",
        type: "address"
      },
      {
        internalType: "uint256",
        name: "Quantity",
        type: "uint256"
      },
      {
        internalType: "uint256",
        name: "Price",
        type: "uint256"
      },
      {
        internalType: "string",
        name: "cert_IPFS_Hash",
        type: "string"
      },
      {
        internalType: "string",
        name: "productID",
        type: "string"
      },
      {
        internalType: "address payable",
        name: "partnerAddress",
        type: "address"
      },
      {
        internalType: "bytes32",
        name: "ethSignedMessageHash",
        type: "bytes32"
      },
      {
        internalType: "bytes",
        name: "valSignature",
        type: "bytes"
      }
    ],
    name: "certRequesterProductLaunch",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool"
      }
    ],
    payable: false,
    stateMutability: "nonpayable",
    type: "function"
  },
  {
    inputs: [],
    payable: true,
    stateMutability: "payable",
    type: "constructor"
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "string",
        name: "msg",
        type: "string"
      },
      {
        indexed: false,
        internalType: "string",
        name: "cert",
        type: "string"
      }
    ],
    name: "certReceived",
    type: "event"
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "string",
        name: "msg",
        type: "string"
      }
    ],
    name: "message",
    type: "event"
  },
  {
    constant: false,
    inputs: [
      {
        internalType: "string",
        name: "productID",
        type: "string"
      },
      {
        internalType: "uint256",
        name: "Price",
        type: "uint256"
      }
    ],
    name: "setRetailPrice",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool"
      }
    ],
    payable: true,
    stateMutability: "payable",
    type: "function"
  },
  {
    constant: false,
    inputs: [
      {
        internalType: "string",
        name: "productID",
        type: "string"
      },
      {
        internalType: "uint256",
        name: "Price",
        type: "uint256"
      }
    ],
    name: "setWholesalePrice",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool"
      }
    ],
    payable: true,
    stateMutability: "payable",
    type: "function"
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "farmerAddress",
        type: "address"
      },
      {
        indexed: false,
        internalType: "string",
        name: "shippingAddress",
        type: "string"
      }
    ],
    name: "shippingAlert",
    type: "event"
  },
  {
    constant: true,
    inputs: [
      {
        internalType: "string",
        name: "productID",
        type: "string"
      }
    ],
    name: "endUserTrace",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string"
      },
      {
        internalType: "address",
        name: "",
        type: "address"
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256"
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [
      {
        internalType: "bytes32",
        name: "_ethSignedMessageHash",
        type: "bytes32"
      },
      {
        internalType: "bytes",
        name: "_signature",
        type: "bytes"
      }
    ],
    name: "recoverSigner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [
      {
        internalType: "bytes",
        name: "sig",
        type: "bytes"
      }
    ],
    name: "splitSignature",
    outputs: [
      {
        internalType: "bytes32",
        name: "r",
        type: "bytes32"
      },
      {
        internalType: "bytes32",
        name: "s",
        type: "bytes32"
      },
      {
        internalType: "uint8",
        name: "v",
        type: "uint8"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  }
]

var contractAddress = '0x18c0e09272d6DEfF70fD6686EaF33e1C4eF20FA6'

var suppliedGas = 3000000

export { ABI, contractAddress, suppliedGas }
