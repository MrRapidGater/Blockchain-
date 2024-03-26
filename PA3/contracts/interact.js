//this script uses the contract we had created (it's ABI and it's contract address) to call specific functions from the smart contract


const net = require('net'); 
const path = require('path'); 
const fs = require('fs-extra'); 
const Web3 = require('web3') 



const web3dataJson = JSON.parse(fs.readFileSync('web3data.json','utf-8'))
const location = web3dataJson.location
console.log('IPC file is located at:', location)
const password = web3dataJson.password 

const web3 = new Web3(new Web3.providers.IpcProvider(location, net)); 

// read in the contracts
const contractJsonPath = path.resolve(__dirname, 'SimpleStorage.json'); 
const contractJson = JSON.parse(fs.readFileSync(contractJsonPath));
const contractAbi = contractJson.abi; 

const contractByteCode = contractJson.bytecode 


//EVERYTHING ABOVE HAS BEEN THE SAME AS IN THE deploy.js function, please look at it to see the detail about what we are attempting above

//in addition, we need the contract address
var data = fs.readFileSync('contAddress.json','utf-8') //read the contAddress.json that got made when you ran deploy.js 
contAddress = JSON.parse(data.toString()).address;
console.log('the contract is at: ', contAddress)

const contractInstance = new web3.eth.Contract(contractAbi,contAddress)  //this is the javascript object that allows us to interact with the smart contract
//importantly: it has member functions with the same names as those in the smart contract ABI


//now lets create the set function
async function set(fromAddress,value)
{
  //you can use the contractInstance to call the set value

  const result = await contractInstance.methods.set(value).send({from: fromAddress, gasLimit: '0xe00000'}) //feel free to experiment with the gas
  //lets break this down a little
  //contractInstance.methods has all the functions in the smart contract which you can call manually, as you would a regular function
  //hence: contractInstance.set.methods(value)

  //but what of the send thing at the end?
  //for any smart contract function that needs gas, we must use .send({from: senderaddress, gasLimit: '0xyourvalueinhexhere'})

}

async function get()
{
  const result = await contractInstance.methods.get().call()
  return result

  //so why are we using .call() here and not .send()
  //.call() is used for solidity VIEW functions that do not use gas

  //Important note: .call() should be used when you want a function to return something from the smart contract to the javascript code
  //.send() can't be used to return variables into javascript and, as such, you will ultimately need setters and getters to interact with smart contracts

  //in addition, if you call a function that returns multiple values, then you get a structure with appropriate fields. The name of the fields are the same as those you set in the solidity contract function
}


async function main()
{
    var myAccount = "";
    await web3.eth.getAccounts().then(e => myAccount = e[0]); //get the list of accounts on your node and put the first one in "myAccount"
    console.log("Your account is: ", myAccount)

    await web3.eth.personal.unlockAccount(myAccount, password, 60) //unlock that particular account using the password for 60 seconds. This authorizes you to act on the behalf of this account such as deploy contracts or send transactions or interact with contracts
    .then(console.log('Account unlocked!')); 

    //call the setter function
    reading = await get()
    console.log('value at the contract currently is: ', reading.retVal,
    reading.retAdd)

    await set(myAccount, 100) //set the value is 100

    reading = await get()
    console.log('value at the contract currently is: ', reading.retVal,
    reading.retAdd)

}

main().then(() => process.exit(0)); //just call the main function

