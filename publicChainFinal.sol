// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.17;

contract SupplyChain {
    // IPFS Hash sample: QmWNWLzEAt3Bik6m8GKc1p8zJGc5LGtNDFavSgsAJVRZfn
    
    string[] certHashes; 
    address[] validators; //hold public addresses of validators in the private chain
    address admin;
    //struct to capture farmer product details 
    struct FarmerInput {
            // string productDetails; // All these details can be retrieved from the product's cert IPFS hash.
            uint256 Quantity;
            uint256 Price;
            string ipfsHashOfCert;
            // address farmerAddress;
            string productID;
            address payable partnerAddress;
        }
    struct ProductIdnrel {
        string productID;
        uint256 Price;
        address partnerAddress;
    }
    
    // relationship between manufacturer and wholesellers
    struct PartnerMaps {
        string  productID;
        address payable wholeseller;
        uint256 Price;
        
    }
    
    // struct binding wholesellers to retailers
     struct WholesellerRetailermap {
        string  productID;
        address retailer; 
        uint256 Price;
        
    }
    
    // Events begin.
    event ShippingAlert (address farmerAddress, string shippingAddress);
    event CertReceived(string msg, string cert);
    event Message(string msg);
    // Events end.
 
    
    mapping(string => PartnerMaps) internal manufacturerWholesellerRelationship; //mapping for manufacturer and wholesellers
    
    mapping(string => FarmerInput) internal fInput; //mapping to hold farmer input
    
    mapping(string => WholesellerRetailermap) internal wholesellerRetailerRelationship; //mapping for wholesellers and retailers
    
    mapping(string => ProductIdnrel) internal prodIDnPriceMap;
    
    constructor () public payable {
           validators.push(0x3136D6e327018d4124C222E15f4aD7fA8621f16E);
           validators.push(0x3136D6e327018d4124C222E15f4aD7fA8621f16E);
           admin = msg.sender;
       }
    
    function certRequesterProductLaunch(address requester, uint256 quantity, uint256 price, string calldata certIpfshash, string calldata productID, address payable partnerAddress, bytes32 ethSignedmessagehash, bytes calldata valSignature) external returns(bool){
        // Perform validation checks.
        require(verifyInclusiveness(certIpfshash, certHashes)==0, "Certificate already exist");
        // check msg.sender matches farmer public address
        require(msg.sender == requester, "Requester public address mismatch");
             
        //require that cert status is approved. Frontend handles.
                 
        //check productID matches productID input parameter. Frontend handles.
        // require(keccak256(abi.encodePacked(JsmnSolLib.getBytes(certRetrievedFromIPFS, pID.start, pID.end))) == keccak256(abi.encodePacked(productID)), "Product ID mismatch");
                 
        // recover validator address from signature & check inclusiveness in validators array
        require(verifyValidator(recoverSigner(ethSignedmessagehash, valSignature), validators) == 1, "Unkown validator");
                 
        certHashes.push(certIpfshash); // Not needed. IPFS hash of certs are unique. Only valid certs can pass and they are already one-to-one with ProductID/Signature of validator.
        fInput[productID] = FarmerInput(quantity,price, certIpfshash, productID, partnerAddress);
        prodIDnPriceMap[productID] = ProductIdnrel(productID, price, partnerAddress);
        emit Message("Product successfully launched on Ethereum testnet");
        return true;
    }
    
    //function to check if IPFS_Hash inputed already exist in the contract
    function verifyInclusiveness(string memory ipfsHash, string[] memory certificateHashes) internal pure returns (uint8){
        for(uint256 i = 0; i < certificateHashes.length; i++){ 
            if ((keccak256(abi.encodePacked((certificateHashes[i]))) == keccak256(abi.encodePacked(((ipfsHash)))))){ 
            // keccak256(abi.encodePacked converts the cert hash to byte before comparing it             
              return 1;
            }
         }      
        return 0;
    }
    
        // verify validator address is part of the validators array
        function verifyValidator(address signer, address[] memory validatorsArray) internal pure returns (uint8){
        for(uint256 i = 0; i < validatorsArray.length; i++){ 
            if (validatorsArray[i] == signer){ 
              return 1; // validator is included
            }
         }      
        return 0; // validator not included
    }
    
    function buyFarmerproduct(address payable farmerAddress, string calldata productID, string calldata shippingAddress, address payable wholeseller) external  payable returns(string memory){
            require(prodIDnPriceMap[productID].Price == msg.value, "Price mismatch");// require product ID price is same as value sent
            require(msg.sender == prodIDnPriceMap[productID].partnerAddress); //require partner address stated by farmer is the address calling this function
            require(address(farmerAddress) != address(0)); 
            manufacturerWholesellerRelationship[productID].productID = productID;
            manufacturerWholesellerRelationship[productID].wholeseller = wholeseller;
            emit ShippingAlert (farmerAddress, shippingAddress);
            emit Message("Farmer Payment Successful"); // Pay farmer alert.
            farmerAddress.transfer(msg.value);
            return "Transaction Successful";
    }
    
    function setWholesaleprice(string calldata productID, uint256 price) external payable returns(bool){
      require (fInput[productID].partnerAddress == msg.sender);
      manufacturerWholesellerRelationship[productID].Price = price;
      return true;
    }
    
    function assetTransferwholseller(string calldata productID, address retailer) external payable returns(bool){
        require( manufacturerWholesellerRelationship[productID].wholeseller == msg.sender);
        require(manufacturerWholesellerRelationship[productID].Price == msg.value, "Price mismatch");
        emit Message(" manufacturer Payment Successful");
        wholesellerRetailerRelationship[productID].retailer = retailer;
        
        fInput[productID].partnerAddress.transfer(msg.value);
        return true;
    }
    
    function setRetailprice(string calldata productID, uint256 price) external payable returns(bool){
      require (manufacturerWholesellerRelationship[productID].wholeseller == msg.sender);
      wholesellerRetailerRelationship[productID].Price = price;
      return true;
    }
    
    function assetTransferretailer(string calldata productID) external payable returns(bool){
        require( wholesellerRetailerRelationship[productID].retailer == msg.sender);
        require(wholesellerRetailerRelationship[productID].Price == msg.value, "Price mismatch");
        emit Message(" wholeseller Payment Successful");
        manufacturerWholesellerRelationship[productID].wholeseller.transfer(msg.value);
        return true;
    }
    
    function endUsertrace(string calldata productID) external  view returns (string memory, address, uint256, uint256) { // returns ipfsHashOfCert, Wseller, Wprice, Rprice
        return (fInput[productID].ipfsHashOfCert, fInput[productID].partnerAddress, manufacturerWholesellerRelationship[productID].Price, wholesellerRetailerRelationship[productID].Price);
    }
    
    function recoverSigner(bytes32 ethSignedmessagehash, bytes memory signerSignature) public pure returns (address){
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(signerSignature);

        return ecrecover(ethSignedmessagehash, v, r, s);
    }

    function splitSignature(bytes memory sig) public pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(sig.length == 65, "invalid signature length");

        assembly {
            /*
            First 32 bytes stores the length of the signature

            add(sig, 32) = pointer of sig + 32
            effectively, skips first 32 bytes of signature

            mload(p) loads next 32 bytes starting at the memory address p into memory
            */

            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // implicitly return (r, s, v)
    }
    //how to generate a unique product ID  for each farmer Input..(remember to search)
}