//this script uses the contract we had created (it's ABI and it's contract address) to call specific functions from the smart contract


const net = require('net');
const path = require('path');
const fs = require('fs-extra');
const Web3 = require('web3')



const web3dataJson = JSON.parse(fs.readFileSync('web3data.json', 'utf-8'))
const location = web3dataJson.location
//console.log('IPC file is located at:', location)
const password = web3dataJson.password

const web3 = new Web3(new Web3.providers.IpcProvider(location, net));

// read in the contracts
const contractJsonPath = path.resolve(__dirname, 'DoubleAuction.json');
const contractJson = JSON.parse(fs.readFileSync(contractJsonPath));
const contractAbi = contractJson.abi;

const contractByteCode = contractJson.bytecode


//EVERYTHING ABOVE HAS BEEN THE SAME AS IN THE deploy.js function, please look at it to see the detail about what we are attempting above

//in addition, we need the contract address
var data = fs.readFileSync('contAddressDoubleAuction.json', 'utf-8') //read the contAddress.json that got made when you ran deployDoubleAuction.js
contAddress = JSON.parse(data.toString()).address;
//console.log('the contract is at: ', contAddress)

const contractInstance = new web3.eth.Contract(contractAbi, contAddress)  //this is the javascript object that allows us to interact with the smart contract
//importantly: it has member functions with the same names as those in the smart contract


//this function is irrelevant to your DoubleAuction.js, feel free to delete it
async function set(fromAddress, value) {
  const result = await contractInstance.methods.set(value).send({ from: fromAddress, gasLimit: '0xe00000' })
}


async function addBuyer(quantity, value, fromAddress) {
  try {
    const result = await contractInstance.methods.addBuyer(quantity, value).send({ from: fromAddress, gasLimit: '0xe00000' });
    console.log(`submitted a buy bid of: ( ${quantity} , ${value} ) from account: ${fromAddress}`)
  } catch (error) {
    console.log(`Error adding buyer of address ${fromAddress}`)
  }

}


async function main() {
  var args = process.argv;
  accountNo = args[4];
  p = args[2];
  q = args[3];

  var myAccount = "";
  await web3.eth.getAccounts().then(e => myAccount = e[accountNo]); //get the list of accounts on your node and put the first one in "myAccount"
  console.log("Your account is: ", myAccount)

  await web3.eth.personal.unlockAccount(myAccount, password, 60) //unlock that particular account using the password for 60 seconds. This authorizes you to act on the behalf of this account such as deploy contracts or send transactions or interact with contracts
    .then(console.log('Account unlocked!'));

  await addBuyer(p, q, myAccount);

}

main().then(() => process.exit(0)); //just call the main function

