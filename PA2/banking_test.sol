// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../contracts/banking_rollnumber_contract.sol";
import "remix_accounts.sol";


contract BankingTest{
    address owner;
    address user1;
    address user2;
    address user3;

    address sc;

    BankingSystem TestSystem;

    function beforeAll() public {
         owner = TestsAccounts.getAccount(0);
         user1 = TestsAccounts.getAccount(1);
         user2 = TestsAccounts.getAccount(2);         
        user3 = TestsAccounts.getAccount(3);
         TestSystem = new BankingSystem();
    }

    
    /// #sender: account-1 (sender is account at index '1')
    function checkUser1Creation() public {
        TestSystem.openAccount("Zain","Nadeem");
        (uint balance2, string memory first_name2, string memory last_name2, uint loanAmount) = TestSystem.getDetails(); 
         Assert.equal(balance2, uint(0), "Wrong Balance Assigned Initially");
        Assert.equal(first_name2, string("Zain"), "Wrong First Name");
        Assert.equal(last_name2, string("Nadeem"), "Wrong Last Name");   
        Assert.equal(loanAmount,0,"Wrong Loan Amount");
    }
   
    /// #sender: account-2 (sender is account at index '2')
    function checkUser2Creation() public {
        TestSystem.openAccount("Uncle","Bob");
        (uint balance2, string memory first_name2, string memory last_name2, uint loanAmount) = TestSystem.getDetails(); 
        Assert.equal(balance2, uint(0), "Wrong Balance Assigned Initially");
        Assert.equal(first_name2, string("Uncle"), "Wrong First Name");
        Assert.equal(last_name2, string("Bob"), "Wrong Last Name");   
        Assert.equal(loanAmount,0,"Wrong Loan Amount");
    }

    /// #sender: account-1 (sender is account at index '1')
    function checkUser1Details() public {
        (uint balance2, string memory first_name2, string memory last_name2, uint loanAmount) = TestSystem.getDetails();  
        Assert.equal(balance2, uint(0), "Wrong Balance");
        Assert.equal(first_name2, string("Zain"), "Wrong First Name");
        Assert.equal(last_name2, string("Nadeem"), "Wrong Last Name");   
        Assert.equal(loanAmount,0,"Wrong Loan Amount");
    } 
        

    // Depositing 10 ether in account 1
    /// #value: 10000000000000000000
    /// #sender: account-1 (sender is account at index '1')
    function checkUser1Deposit() public payable {
        TestSystem.depositAmount{value:10000000000000000000}();
        (uint balance2, string memory first_name2, string memory last_name2, uint loanAmount) = TestSystem.getDetails(); 
        Assert.equal(balance2, 10000000000000000000, "Wrong Balance");
        Assert.equal(first_name2, string("Zain"), "Wrong First Name");
        Assert.equal(last_name2, string("Nadeem"), "Wrong Last Name");            
        Assert.equal(loanAmount,0,"Wrong Loan Amount");
    } 
        
    /// #sender: account-1 (sender is account at index '1')
    function TransferETH() public {
        address payable userP2 = payable(user2);
        TestSystem.TransferEth(userP2,5000000000000000000);
        // 1 ETH would be left in Zain's Account - CHECKING
        (uint balance2, string memory first_name2, string memory last_name2, uint loanAmount) = TestSystem.getDetails(); 
        Assert.equal(balance2, 5000000000000000000, "Wrong Balance");
        Assert.equal(first_name2, string("Zain"), "Wrong First Name");
        Assert.equal(last_name2, string("Nadeem"), "Wrong Last Name");   
        Assert.equal(loanAmount,0,"Wrong Loan Amount");
    } 

    // We try to withdrawl 1 ether from smart contract to wallet of user 1
    /// #sender: account-1 (sender is account at index '1')
    function checkWithDrawalFromUser() public {
        // this stores the smart contract address
        // this should take 1 ether from smart contract and transfer it to user 1's wallet
        TestSystem.withDraw(1000000000000000000);
        (uint balance2, string memory first_name2, string memory last_name2, uint loanAmount) = TestSystem.getDetails(); 
        Assert.equal(balance2, 4000000000000000000, "Wrong Balance");
        Assert.equal(first_name2, string("Zain"), "Wrong First Name");
        Assert.equal(last_name2, string("Nadeem"), "Wrong Last Name");
        Assert.equal(loanAmount,0,"Wrong Loan Amount");   
        
    }

    // 1 ETH transferred to Account 2
    /// #sender: account-2 (sender is account at index '2')
    function checkCorrectTransfer() public {
        (uint balance2, string memory first_name2, string memory last_name2, uint loanAmount) = TestSystem.getDetails(); 
        Assert.equal(balance2, 5000000000000000000, "Wrong Balance");
        Assert.equal(first_name2, string("Uncle"), "Wrong First Name");
        Assert.equal(last_name2, string("Bob"), "Wrong Last Name"); 
        Assert.equal(loanAmount,0,"Wrong Loan Amount");  
    } 

    /// #sender: account-1 (sender is account at index '1')
    function checkingWithdrawalFromBankSide() public {
        Assert.equal(TestSystem.AmountInBank(),9000000000000000000,"Incorrect Balance In Bank");
    } 


    /// #value: 10000000000000000000
    /// #sender: account-0 (sender is account at index '0')
    function checkLoanFund() public payable {
        TestSystem.depositTopUp{value:10000000000000000000}();        
    }

    /// #sender: account-1 (sender is account at index '1')
    function checkingTopUp() public {
        Assert.equal(TestSystem.AmountInBank(),19000000000000000000,"Incorrect Balance In Bank");
    }

    /// #value: 1000000000000000000
    /// #sender: account-1 (sender is account at index '0')
    function checkLoanFundOthers() public payable {
        try TestSystem.depositTopUp{value:1000000000000000000}() 
        {

        } catch Error (string memory reason) {
            Assert.equal(reason,string("Only Owner can call this function"),"Incorrect Error Message");
        }
        
    }
    
    /// #sender: account-1 (sender is account at index '1')
    function checkingTopByOthers() public {
        Assert.equal(TestSystem.AmountInBank(),19000000000000000000,"Other Users Cannot Deposit Amount!");
    }

    
    // user 2, asks for a loan of 1 ether funds in the bank
    uint public orignalBalance = 0;
     uint public BalanceAfterLoan = 0;
    /// #sender: account-2 (sender is account at index '2') 
    function CheckloanFunctioning() public { 
        orignalBalance = user2.balance;
        TestSystem.TakeLoan(1000000000000000000);  
        BalanceAfterLoan = user2.balance;   
    }

    /// #sender: account-2 (sender is account at index '2')
    function CheckingLoanTransferred() public {
        uint loantaken = TestSystem.InquireLoan();
        Assert.equal(loantaken, uint(1000000000000000000), "Wrong Loan Record");
        Assert.equal(loantaken, uint(BalanceAfterLoan-orignalBalance), "Wrong Last Name");   
    }

        
    function checkingLoanByBank() public {
        Assert.equal(TestSystem.AmountInBank(),18000000000000000000,"Other Users Cannot Deposit Amount!");
    }

    /// #value: 1000000000000000000
    /// #sender: account-2 (sender is account at index '2')
    function checkReturnLoan() public payable {
        TestSystem.returnLoan{value:1000000000000000000}();
    }

    function checkingReturnLoanInBank() public {
        Assert.equal(TestSystem.AmountInBank(),19000000000000000000,"Other Users Cannot Deposit Amount!");
    }

      /// #sender: account-2 (sender is account at index '2')
    function CheckLoanRecordOfUser() public {
        uint loantaken = TestSystem.InquireLoan();
        Assert.equal(loantaken, uint(0), "Wrong Loan Record");
    }

    
}  
