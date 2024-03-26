// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

contract BankingSystem {
    // DECLARATIONS

    // CODE

    // Constructor
    constructor() {

    }


    // TASK 1
    function openAccount(string memory firstName, string memory lastName) public {
        // Code Here!!
    }

    
    // TASK 2
    function getDetails() public view returns (uint balance, string memory first_name, string memory last_name, uint loanAmount) {   
        // Code Here!!
    }


    // TASK 3
    // minimum deposit of 1 ether.
    // 1 ether = 10^18 Wei.   
    function depositAmount() public payable {    
        // Code Here!!
    }

    
    // Task 4
    function withDraw(uint withdrawalAmount) public {                
        // Code Here!!
    }
    
        
    // Task 5
    function TransferEth(address payable reciepent, uint transferAmount) public {
        // Code Here!!
    }


    // Task 6.1
    function depositTopUp() public payable {
        // Code Here!!
    }


    // Task 6.2
    function TakeLoan(uint loanAmount) public {
        // Code Here!!
    }
        

    // Task 6.3
    function InquireLoan() public view returns (uint loanValue) {
        // Code Here!!
    }


    // Task 7 
    function returnLoan() public payable  {
        // Code Here!!
    }


    function AmountInBank() public view returns(uint) {
            // DONT ALTER THIS FUNCTION
            return address(this).balance;
    }
     

    
}   

