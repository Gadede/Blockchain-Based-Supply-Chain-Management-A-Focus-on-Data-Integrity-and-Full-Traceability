<template>
  <div class="home">
    <div id="topNav">
      <el-link icon="el-icon-arrow-left" style="font-size:17px;float:left;" @click="backToPrvPg">Previous Page</el-link>
    </div>
    <!--<img alt="Vue logo" src="../assets/logo.png">--->
        <h3>Cert requester product launch</h3>
            <el-row>
              <el-col :span="22">
                <el-form
                :model="productlaunch"
                :rules="rules"
                ref="productlaunch"
                label-width="165px"
              >
                <el-col :span="9">
                  <el-form-item label="Product ID" prop="prodID">
                  <el-input v-model="productlaunch.prodID" placeholder="Please enter Product ID."></el-input>
                  </el-form-item>
                  <el-form-item label="Product quantity" prop="quantity">
                    <el-input-number v-model="productlaunch.quantity" :min="1"></el-input-number>
                  </el-form-item>
                  <el-form-item label="Unit Price (Yuan)" prop="price">
                      <el-input-number v-model="productlaunch.price" :min="1"></el-input-number>
                    </el-form-item>
                  </el-col>

                  <el-col :span="12" :offset="2">
                    <el-form-item label="Partner addresss" prop="partnerAddr">
                    <el-input v-model="productlaunch.partnerAddr" placeholder="Please enter partner address."></el-input>
                    </el-form-item>
                     <el-form-item label="IPFS hash" prop="IPFS_Hash">
                    <el-input v-model="productlaunch.IPFS_Hash" placeholder="Please enter product IPFS hash."></el-input>
                  </el-form-item>
                  </el-col>

                  <el-col :span="14" :offset="1">
                    <el-form-item label="**Consent**" prop="authCheckBox">
                      <el-checkbox v-model="productlaunch.authCheckBox">I understand the implication of this action.</el-checkbox>
                    </el-form-item>
                  </el-col>
                </el-form>
              </el-col>
            </el-row>
            <br>
            <el-row>
              <el-button :loading="productLaunchLoadBtn" @click="processFormData('productlaunch')" type="primary" plain>Launch product</el-button>
              <el-button @click="resetForm('productlaunch')">Reset</el-button>
            </el-row>
    </div>
</template>

<script>
// @ is an alias to /src
// import HelloWorld from '@/components/HelloWorld.vue'
import ethEnabled from '@/assets/js/web3nMetaMask'
// import * as signatureGenerator from '@/assets/js/signatureHelperFunc'
// import getHash from '@/assets/js/hashFunc'
import { ABI, contractAddress, suppliedGas } from '@/assets/js/pubChainSCabi'
import web3 from '@/assets/js/web3Only'
const ipfs = new window.Ipfs()

export default {
  data () {
    return {
      productlaunch: {
        prodID: '',
        quantity: '',
        price: '',
        partnerAddr: '',
        IPFS_Hash: '',
        authCheckBox: false
      },
      // Dynamic variables.
      prodDetailsHash: '',
      ethHashedData: null,
      valSignature: '',
      addrOfCertRequester: '',
      IPFSHashOfUploadedCert: '',
      prepData: null,
      // Loading states
      loadingCertCreationgPage: true,
      productLaunchLoadBtn: false,
      prodData: null,
      rules: {
        prodID: [
          { required: true, message: 'Please input product ID', trigger: 'blur' },
          { min: 6, message: 'Length should be at least 6', trigger: 'blur' }
        ],
        quantity: [
          { required: true, message: 'Please input product description', trigger: 'blur' }
        ],
        IPFS_Hash: [
          { required: true, message: 'Please input IPFS hash of product', trigger: 'blur' },
          { min: 5, message: 'Length should be at least 5', trigger: 'blur' }
        ],
        price: [
          { required: true, message: 'Please input origin of product', trigger: 'blur' }
        ],
        partnerAddr: [
          { required: true, message: 'Please input address of partner', trigger: 'blur' },
          { min: 5, message: 'Length should be at least 5', trigger: 'blur' }
        ]
      }
    }
  },
  created () {
    if (!ethEnabled()) {
      this.$message('Please install an Ethereum-compatible browser or extension like MetaMask to use this dApp!')
    } else {
      this.loadingCertCreationgPage = false
      this.getAccount().then(accounts => {
        this.addrOfCertRequester = accounts[0]
        console.log('Address of cert requester: ', this.addrOfCertRequester)
      })
    }
  },
  methods: {
    async getAccount () {
      var accounts = await window.ethereum.request({ method: 'eth_requestAccounts' })
      return accounts
    },
    async sendTnx (txParams) {
      // Transaction execution in Ethereum from Metamask
      var txReceipt = await window.ethereum.request({ method: 'eth_sendTransaction', params: [txParams] })
      return txReceipt
    },
    processFormData (formName) {
      console.log('Pulling cert from IPFS')
      if (this.productlaunch.authCheckBox === true) {
        this.$refs[formName].validate(valid => {
          this.productLaunchLoadBtn = true
          if (valid) {
            this.prodData = {
              prodID: this.productlaunch.prodID,
              quantity: this.productlaunch.quantity,
              price: this.productlaunch.price,
              partnerAddr: this.productlaunch.partnerAddr,
              IPFS_Hash: this.productlaunch.IPFS_Hash
            }
            // Validation completed. Proceed with main logic.
            // Get data from IPFS.
            ipfs.cat(this.prodData.IPFS_Hash).then(retrievedData => {
              var certRetrievedFromIPFS = JSON.parse(retrievedData.toString()) // Convert to string and parse as JSON object.
              console.log('Cert from IPFS: ', certRetrievedFromIPFS)
              console.log('Retrieved productID: ', certRetrievedFromIPFS.prodID)
              if (this.prodData.prodID === certRetrievedFromIPFS.prodID && this.prodData.quantity === certRetrievedFromIPFS.quantity && web3.utils.toChecksumAddress(this.addrOfCertRequester) === web3.utils.toChecksumAddress(certRetrievedFromIPFS.public_blockchainAddress)) {
                if (certRetrievedFromIPFS.certStatus === '1') {
                  // All checks passed. More checks to be done by Smart contract.
                  console.log('Proceeding to smart contract')
                  // Initialize Smart contract.
                  var pubChainContract = new web3.eth.Contract(ABI, contractAddress, { defaultGas: suppliedGas })
                  try {
                    // Transaction parameters
                    const txParams = {
                      from: this.addrOfCertRequester,
                      to: contractAddress,
                      data: pubChainContract.methods.certRequesterProductLaunch(web3.utils.toChecksumAddress(this.addrOfCertRequester), this.prodData.quantity, this.prodData.price, this.prodData.IPFS_Hash, this.prodData.prodID, this.prodData.partnerAddr, certRetrievedFromIPFS.prodDetailsHash, certRetrievedFromIPFS.valSignature).encodeABI()
                    }
                    this.sendTnx(txParams).then(tnxReceipt => {
                      console.log('Transaction receipt: ', tnxReceipt)
                      this.$message({
                        message: 'Transaction successful.',
                        type: 'success'
                      })
                      this.$alert('Transaction hash : ' + tnxReceipt, 'Transaction success', {
                        confirmButtonText: 'OK',
                        callback: action => {
                          this.$message({
                            type: 'info',
                            message: 'Successful transaction'
                          })
                        }
                      })
                      this.productLaunchLoadBtn = false
                    })
                  } catch {
                    console.log('Sorry! Error occured.')
                    this.productLaunchLoadBtn = false
                    this.$message.error('Non-transactional error. Please try again later.')
                  }
                } else {
                  this.$message.error('Oops! Your certificate is not approved.')
                }
              } else {
                this.$message.error('Sorry! Invalid product ID, Quantity or Address.')
              }
            }).catch(err => {
              console.log('Error pulling data from IPFS.', err)
              this.$message.error('Oops, Error adding certificate to IPFS')
            })
          } else {
            console.log('Submission error.')
            this.productLaunchLoadBtn = false
            return false
          }
          console.log('Cert requester product details: ', this.prodData)
        })
      } else {
        this.$message('Please check the checkbox')
      }
    },
    resetForm (formName) {
      this.$refs[formName].resetFields()
    },
    backToPrvPg () {
      this.$router.push('/')
    }
  }
}
</script>
<style scoped>
.home {
  background-color: #ffffff;
  border-radius: 4px;
  margin: 0.1% auto;
  width: 75%;
  padding: 1rem 1.5rem;
}
#topNav{
  margin-top: -3%;
  margin-bottom: 5%;
  width: 100%;
  height: 3%;
}
</style>
