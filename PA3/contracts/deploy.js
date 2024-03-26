//this code deploys the contract in SimpleStorage.json to the blockchain and stores the transaction address of the contract in contAddress.json for use by your other javascript scripts


const net = require('net'); //the net library for javascript, useful for creating sockets etc but we will not be doing anything with it except for the web3 injection below
const path = require('path'); //useful for getting paths
const fs = require('fs-extra'); //the file read library
const Web3 = require('web3') //the collection of libraries that is essential for interacting with a blockchain.
//web3 has many useful function for deploying and interacting with smartcontracts as well as more basic tasks such as unlocking accounts and sending transactions




//read the web3data.json file to get the location and password
const web3dataJson = JSON.parse(fs.readFileSync('web3data.json','utf-8'))
const location = web3dataJson.location
console.log('IPC file is located at:', location)
const password = web3dataJson.password //this is the password of your linux user as well, and is common between all your acccounts


const web3 = new Web3(new Web3.providers.IpcProvider(location, net)); //get the web3 injection from where your ipc file is located
//if you get an error saying there is no IPC file, make sure that startup.sh has been started appropriately, check output.log. if the node is running, the ipc file should exist
//alternatively debug any path issues, make sure the path in the error points to the right location

// read in the contracts
const contractJsonPath = path.resolve(__dirname, 'SimpleStorage.json'); //get the past of where SimpleStorage.json is. Feel free to alter to point to your contract
const contractJson = JSON.parse(fs.readFileSync(contractJsonPath));
const contractAbi = contractJson.abi; //this is the abi file which contains a basic description of the functions and variables in the smart contracts
//the basic description includes what variables exist, what their types are, what functions take as inputs, what they return as outputs, what are the names of variables etc

const contractByteCode = contractJson.bytecode //this is the raw bytecode from the compilation of the contract


const contractInstance = new web3.eth.Contract(contractAbi) //this is a javascript object that contains the functions. We will discuss this more in the interact.js file



 async function createContract( contractAbi, contractByteCode, contractInit, fromAddress) 
{ //this function deploys the smart contract
  //it uses 4 things
  //contractAbi is the ABI of the smart contract
  //contractByteCode is the bytecode of the deployed contract
  //from address is the public address of the account that is deploying the contract
  //contractInit is an usigned integer. It is only relevant for this contract because this contract has a constructor that takes in a uint.
  //if you have a contract without a constructor, then the arguments field below may be left empty such as 
  //  .deploy({ data: '0x'+contractByteCode})
  //similarly, you may give more than one argument as [contractInit, otherInput]

 const ci = await contractInstance //deploy the contract
    .deploy({ data: '0x'+contractByteCode, arguments: [contractInit] })
    .send({ from: fromAddress, gasLimit: "0xe00000" }) //this is the gas limit. Do not set a gas limit too high as ethereum has a max limit (if you exceed this, you will get an error about having more than 53 bits)
    .on('transactionHash', function(hash){
      console.log("The transaction hash is: " + hash);
    });
  return ci; //return the receipt
};


  async function main()
{
    var myAccount = "";
    await web3.eth.getAccounts().then(e => myAccount = e[0]); //get the list of accounts on your node and put the first one in "myAccount"
    console.log("Your account is: ", myAccount)

    await web3.eth.personal.unlockAccount(myAccount, password, 60) //unlock that particular account using the password for 60 seconds. This authorizes you to act on the behalf of this account such as deploy contracts or send transactions or interact with contracts
    .then(console.log('Account unlocked!')); 

   var tAddress = "";

   await createContract(contractAbi, contractByteCode, 47, myAccount) //call the createContract function using the contractAbiy, bytecode, constructor and deployer address
    .then(async function(ci){
      tAddress = ci.options.address;
    }).catch(console.error);

     console.log('contract address', tAddress) //this is address of the contract

     var contAddress = //a simple struct of the address, we will save this as a JSON file called contAddress.json
     {
      'address': tAddress
     };
     var data = JSON.stringify(contAddress, null, 4); //convert the contAddress variable to a string (complete with all the required brakets and colons)

    await fs.writeFileSync('contAddress.json', data) //save the file as a JSON file
}

main().then(() => process.exit(0)); //just call the main function

