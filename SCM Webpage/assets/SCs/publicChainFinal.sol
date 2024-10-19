// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.17;

contract supplychain {
    // IPFS Hash sample: QmWNWLzEAt3Bik6m8GKc1p8zJGc5LGtNDFavSgsAJVRZfn
    
    string[] cert_Hashes; 
    address[] validators; //hold public addresses of validators in the private chain
    address admin;
    //struct to capture farmer product details 
    struct farmerInput {
            // string productDetails; // All these details can be retrieved from the product's cert IPFS hash.
            uint256 Quantity;
            uint256 Price;
            string ipfsHashOfCert;
            // address farmerAddress;
            string productID;
            address payable partnerAddress;
        }
    struct productIDnPrRel {
        string productID;
        uint256 Price;
        address partnerAddress;
    }
    
    // relationship between manufacturer and wholesellers
    struct partnerMaps {
        string  productID;
        address payable wholeseller;
        uint256 Price;
        
    }
    
    // struct binding wholesellers to retailers
     struct wholeseller_RetailerMap {
        string  productID;
        address retailer; 
        uint256 Price;
        
    }
    
    // Events begin.
    event shippingAlert (address farmerAddress, string shippingAddress);
    event certReceived(string msg, string cert);
    event message(string msg);
    // Events end.
 
    
    mapping(string => partnerMaps) internal manufacturer_wholeseller_Relationship; //mapping for manufacturer and wholesellers
    
    mapping(string => farmerInput) internal f_input; //mapping to hold farmer input
    
    mapping(string => wholeseller_RetailerMap) internal wholeseller_Retailer_Relationship; //mapping for wholesellers and retailers
    
    mapping(string => productIDnPrRel) internal prodIDnPriceMap;
    
    constructor () public payable {
           validators.push(0x50942a4cf3D43854bE8ce2025361d8571b05B05A);
           validators.push(0xEC5bF0F1DE02E5FC8FdE5ADEbe12bD4239535b7C);
           admin = msg.sender;
       }
    
    function certRequesterProductLaunch(address requester, uint256 Quantity, uint256 Price, string memory cert_IPFS_Hash, string memory productID, address payable partnerAddress, bytes32 ethSignedMessageHash, bytes memory valSignature) public  returns(bool){
        // Perform validation checks.
        require(verifyInclusiveness(cert_IPFS_Hash, cert_Hashes)==0, "Certificate already exist");
        // check msg.sender matches farmer public address
        require(msg.sender == requester, "Requester public address mismatch");
             
        //require that cert status is approved. Frontend handles.
                 
        //check productID matches productID input parameter. Frontend handles.
        // require(keccak256(abi.encodePacked(JsmnSolLib.getBytes(certRetrievedFromIPFS, pID.start, pID.end))) == keccak256(abi.encodePacked(productID)), "Product ID mismatch");
                 
        // recover validator address from signature & check inclusiveness in validators array
        require(verifyValidator(recoverSigner(ethSignedMessageHash, valSignature), validators) == 1, "Unkown validator");
                 
        cert_Hashes.push(cert_IPFS_Hash); // Not needed. IPFS hash of certs are unique. Only valid certs can pass and they are already one-to-one with ProductID/Signature of validator.
        f_input[productID] = farmerInput(Quantity,Price, cert_IPFS_Hash, productID, partnerAddress);
        prodIDnPriceMap[productID] = productIDnPrRel(productID, Price, partnerAddress);
        emit message("Product successfully launched on Ethereum testnet");
        return true;
    }
    
    //function to check if IPFS_Hash inputed already exist in the contract
    function verifyInclusiveness(string memory IPFS_Hash, string[] memory certHashes) internal pure returns (uint8){
        for(uint256 i = 0; i < certHashes.length; i++){ 
            if ((keccak256(abi.encodePacked((certHashes[i]))) == keccak256(abi.encodePacked(((IPFS_Hash)))))){ 
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
    
    function Buy_Farmer_Product(address payable farmer_Address, string memory productID, string memory shippingAddress, address payable wholeseller) public payable returns(string memory){
            require(prodIDnPriceMap[productID].Price == msg.value, "Price mismatch");// require product ID price is same as value sent
            require(msg.sender == prodIDnPriceMap[productID].partnerAddress); //require partner address stated by farmer is the address calling this function
            farmer_Address.transfer(msg.value);
            emit message("Farmer Payment Successful"); // Pay farmer alert.
            manufacturer_wholeseller_Relationship[productID].productID = productID;
            manufacturer_wholeseller_Relationship[productID].wholeseller = wholeseller;
            emit shippingAlert (farmer_Address, shippingAddress);
            return "Transaction Successful";
    }
    
    function setWholesalePrice(string memory productID, uint256 Price) public payable returns(bool){
      require (f_input[productID].partnerAddress == msg.sender);
      manufacturer_wholeseller_Relationship[productID].Price = Price;
      return true;
    }
    
    function assetTransfer_wholseller(string memory productID, address retailer) public payable returns(bool){
        require( manufacturer_wholeseller_Relationship[productID].wholeseller == msg.sender);
        require(manufacturer_wholeseller_Relationship[productID].Price == msg.value, "Price mismatch");
        f_input[productID].partnerAddress.transfer(msg.value);
        emit message(" manufacturer Payment Successful");
        
        wholeseller_Retailer_Relationship[productID].retailer = retailer;
        return true;
    }
    
    function setRetailPrice(string memory productID, uint256 Price) public payable returns(bool){
      require (manufacturer_wholeseller_Relationship[productID].wholeseller == msg.sender);
      wholeseller_Retailer_Relationship[productID].Price = Price;
      return true;
    }
    
    function assetTransfer_retailer(string memory productID) public payable returns(bool){
        require( wholeseller_Retailer_Relationship[productID].retailer == msg.sender);
        require(wholeseller_Retailer_Relationship[productID].Price == msg.value, "Price mismatch");
        manufacturer_wholeseller_Relationship[productID].wholeseller.transfer(msg.value);
        emit message(" wholeseller Payment Successful");
        return true;
    }
    
    function endUserTrace(string memory productID) public view returns (string memory, address, uint256, uint256) { // returns ipfsHashOfCert, Wseller, Wprice, Rprice
        return (f_input[productID].ipfsHashOfCert, f_input[productID].partnerAddress, manufacturer_wholeseller_Relationship[productID].Price, wholeseller_Retailer_Relationship[productID].Price);
    }
    
    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns (address){
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
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