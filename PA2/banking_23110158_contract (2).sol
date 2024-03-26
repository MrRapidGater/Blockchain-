// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

contract BankingSystem {
    // DECLARATIONS

    uint256 loan_bal;
    // Struct to hold user account details
    struct Account {
        string firstName;
        string lastName;
        uint256 loanAmount;
        uint256 balance;
        bool exists;
    }

    // CODE

     // Mapping to map user's address to their account details
    mapping(address => Account) private accounts;
    
    // Owner address
    address payable private  owner;

    // Constructor
    constructor() {
       owner = payable(tx.origin);
    }


    // TASK 1
    function openAccount(string memory firstName, string memory lastName) public {
       // Check if the account is already created
        require(accounts[tx.origin].exists == false, "Account already exists");
        
        // Check if the caller is not the owner
        require(tx.origin != owner, "Error, Owner Prohibited");
        
        // Create a new account for the user
        
        // Map user's address to their account details
        accounts[tx.origin] = Account(firstName, lastName, 0, 0, true);
        
        // Code Here!!
    }

    
    // TASK 2
    function getDetails() public view returns (uint balance, string memory first_name, string memory last_name, uint loanAmount) {   
        // Code Here!!
        require(accounts[tx.origin].exists == true, "No Account");

        Account memory account = accounts[tx.origin];
        return (account.balance, account.firstName, account.lastName, account.loanAmount);

    }


    // TASK 3
    // minimum deposit of 1 ether.
    // 1 ether = 10^18 Wei.   
    function depositAmount() public payable {    
        // Code Here!!
          // Check if the user has an account
        require(accounts[tx.origin].exists == true, "No Account");
        require(tx.origin != owner, "Error, Owner Prohibited");

        // Check if the deposit amount is equal or greater than the minimum deposit requirement
        require(msg.value >= 1 ether, "Low Deposit");

        // Update the user's account balance
        accounts[tx.origin].balance += msg.value;

        // Deduct the deposited amount from the user's wallet
        // address payable sender = payable(tx.origin);
        // sender.transfer(msg.value);
    }

    
    // Task 4
    function withDraw(uint withdrawalAmount) public {        
          // Check if the user has an account
          require(tx.origin != owner, "Error, Owner Prohibited");
          require(accounts[tx.origin].exists == true, "No Account");
          
          // Check if the withdrawal amount is less than or equal to the user's balance
          require(withdrawalAmount <= accounts[tx.origin].balance, "Insufficient Funds");

          // Check if the caller is not the owner

          // Transfer the amount to the user's wallet
        //   address payable recipient = payable(tx.origin);
          owner.transfer(withdrawalAmount);

          // Update the user's account balance
          accounts[tx.origin].balance -= withdrawalAmount;             
          // Code Here!!
    }
    
        
    // Task 5
    function TransferEth(address payable reciepent, uint transferAmount) public {
        // Code Here!!
          // Check if the user has an account
          require(tx.origin != owner, "Error, Owner Prohibited");
          require(accounts[tx.origin].exists == true, "No Account");

          // Check if the transfer amount is less than or equal to the user's balance
          require(transferAmount <= accounts[tx.origin].balance, "Insufficient Funds");

          // Check if the recipient has an account
          require(accounts[reciepent].exists == true, "Recipient has no account");

          // Check if the caller is not the owner

          // Transfer the amount to the recipient's account
        //   reciepent.transfer(transferAmount);

          // Update the sender's account balance
          accounts[tx.origin].balance -= transferAmount;

          // Update the recipient's account balance
          accounts[reciepent].balance += transferAmount;
                 
    }


    // Task 6.1
    function depositTopUp() public payable {
        // Code Here!!
        // Check if the caller is the owner
        require(tx.origin == owner, "Only Owner can call this function");
        loan_bal+=msg.value;
        // Deposit the amount to the bank's reserve
        // Code Here!!
    }


    // Task 6.2
    function TakeLoan(uint loanAmount) public {
        // Code Here!!
        // Check if the caller is not the owner
        require(tx.origin != owner, "Error, Owner Prohibited");

        // Check if the user has an account
        require(accounts[tx.origin].exists == true, "No Account");

        // Check if the requested loan amount is greater than 0
        require(loanAmount > 0, "Invalid Loan Amount");

        // Check if the loan amount is greater than the funds available for loans
        require(loanAmount <= loan_bal, "Insufficient Loan Funds");

        // Check if the requested loan amount is more than twice the user's bank balance
        require(loanAmount <= (accounts[tx.origin].balance * 2), "Loan Limit Exceeded");

        // Update the user's loan amount
        accounts[tx.origin].loanAmount = loanAmount;
        payable(tx.origin).transfer(loanAmount);
        loan_bal -= loanAmount;

        // Deduct the loan amount from the bank's reserve
        // Code Here!!
    }
        

    // Task 6.3
    function InquireLoan() public view returns (uint loanValue) {
        // Code Here!!
        // Check if the user has an account
        require(accounts[tx.origin].exists == true, "No Account");

        // Return the user's loan amount
        return accounts[tx.origin].loanAmount;
    }


    // Task 7 
    function returnLoan() public payable  {
         // Code Here!!
       
        // Check if the user has an account
        require(accounts[tx.origin].exists == true, "No Account");

        // Check if the user owes any amount
        require(accounts[tx.origin].loanAmount > 0, "No Loan");

        // Check if the user is trying to return more than what they owe
       require(msg.value <= accounts[tx.origin].loanAmount, "Owed Amount Exceeded");

        // Update the user's loan amount and balance
        accounts[tx.origin].loanAmount -= msg.value;

        // Update the total loan balance of the bank
          loan_bal -= msg.value;            
    }


    function AmountInBank() public view returns(uint) {
            // DONT ALTER THIS FUNCTION
            return address(this).balance;
    }
     

    
}   

