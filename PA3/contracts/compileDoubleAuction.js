const fs = require('fs').promises;
const solc = require('solc');

async function main()
{
  // Load the contract source code
  const sourceCode = await fs.readFile('DoubleAuction.sol', 'utf8');
  // Compile the source code and retrieve the ABI and bytecode
  const { abi, bytecode } = compile(sourceCode, 'DoubleAuction'); //you may alter to point to a contract that you have
  // Store the ABI and bytecode into a JSON file
  const artifact = JSON.stringify({ abi, bytecode }, null, 2);
  await fs.writeFile('DoubleAuction.json', artifact);
}

function compile(sourceCode, contractName) {
  // Create the Solidity Compiler Standard Input and Output JSON
  const input = {
    language: 'Solidity',
    sources: { main: { content: sourceCode } },
    settings: { outputSelection: { '*': { '*': ['abi', 'evm.bytecode'] } } },
  };
  // Parse the compiler output to retrieve the ABI and bytecode
  const output = solc.compile(JSON.stringify(input));
  const artifact = JSON.parse(output).contracts.main[contractName];
  return {
    abi: artifact.abi,
    bytecode: artifact.evm.bytecode.object,
  };
}

main().then(() => process.exit(0));

//The basic pipeline is as follows
// compileDoubleAuction.js (uses a solidity compiler to create a bytecode and abi and store it in a json file)
//->  deployDoubleAuction.js (uses the contract json to deploy the contract onto the blockchain and stores the contract address in a json file)
//-> you can then call addBuyers.js/addSellers.js/DoubleAuction.js/getResults.js to interact with the smart contract
