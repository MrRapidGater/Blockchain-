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


async function getResults() {
    //your code to receive and print the results from the last Double Auction goes here

    try {
        const result = await contractInstance.methods.getResults().call();
        if (result.length == 0)
            return;

        console.log('index\t sellAddresses\t\t\t\t\t buyAddresses\t\t\t\t\t C\t Q');
        for (let i = 0; i < result.length; i++) {
            console.log(i + 1, "\t", result[i].seller, "\t", result[i].buyer, "\t", result[i].C, "\t", result[i].Q);
        }

    } catch (e) {

    }



}

async function main() {
    var myAccount = "";
    await web3.eth.getAccounts().then(e => myAccount = e[0]); //get the list of accounts on your node and put the first one in "myAccount"
    //    console.log("Your account is: ", myAccount)

    await web3.eth.personal.unlockAccount(myAccount, password, 60) //unlock that particular account using the password for 60 seconds. This authorizes you to act on the behalf of this account such as deploy contracts or send transactions or interact with contracts
    //    .then(console.log('Account unlocked!'));

    //    console.log('The value at the contract is: ', result);

    await getResults();
}

main().then(() => process.exit(0)); //just call the main function

