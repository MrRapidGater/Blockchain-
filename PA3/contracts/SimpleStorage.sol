pragma solidity ^0.8.7; //use solidity version above 0.8.7 (upto but not 0.9.0)

contract SimpleStorage {
  uint private storedData; //a private variable
  address senderAddress;

  constructor(uint initVal) public { //have a constructor with the default variable initVal.
    //it is public so other contracts (or our javascript code) can interact with it. 
    storedData = initVal;
  }

  function set(uint x) public { //this is a public function, similar to the constructor. You can give it an input and it stores it in storedData
    storedData = x;
    senderAddress = msg.sender ;
  }

  function get() view public returns (uint retVal, address retAdd) { //this function is of type 'view', that means it doesn't cost gas.
    return (storedData , senderAddress) ;
  }

  
}
