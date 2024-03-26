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

    // User 1 created an account
    /// #sender: account-1 (sender is account at index '1')
    function openAcc1() public {
        TestSystem.openAccount("Zain","Nadeem");
    }

    uint public cnt = 0;
    /// #sender: account-1 (sender is account at index '1')
    /// #value: 500
    function TryDepositingLessThanMinimumAmount() public payable  {
        try TestSystem.depositAmount{value:500}()
        {
            // Here the owner is calling this function, IF he is able to make an account than case fails.
            cnt = 1;      
        }  catch Error(string memory reason)
        {
            // If the owner is unable to create an account, it comes here & the reason should be caught.
            // if the owner is unable to create an account, it will return the string reason which should be as in manual.
            Assert.equal(reason,string("Low Deposit"),"Not giving the correct error");
        }
         Assert.equal(cnt, 0,"It is allowing less than 1 ether to be deposited!");     
    }


    uint public cont = 0;
    /// #sender: account-3 (sender is account at index '1')
    /// #value: 5000000000000000000
    function TryDepositingWithNoAccount() public payable  {
        try TestSystem.depositAmount{value:5000000000000000000}()
        {
            // Here the owner is calling this function, IF he is able to make an account than case fails.
            cont = 1;      
        }  catch Error(string memory reason)
        {
            // If the owner is unable to create an account, it comes here & the reason should be caught.
            // if the owner is unable to create an account, it will return the string reason which should be as in manual.
            Assert.equal(reason,string("No Account"),"Not giving the correct error");
        }
         Assert.equal(cont, 0,"It is allowing a user with no account to deposit!!");     
    }

    
    uint public contr = 0;
    /// #sender: account-1 (sender is account at index '1')
    function checkWithdrawingGreaterThanBalance() public {
        try TestSystem.withDraw(1000000000000000000) 
        {
            contr = 1;
        }
        catch Error(string memory reason)
        {
            Assert.equal(reason,string("Insufficient Funds"),"It is not giving the right error message");
        }
        Assert.equal(contr, 0,"It is allowing the user to withdraw more than his bank balance.");     
    }
    
    /// #value: 2000000000000000000
    /// #sender: account-1 (sender is account at index '1')
    function Account1Deposits2Ether() public payable {
        TestSystem.depositAmount{value:2000000000000000000}();
    }

    uint public conter = 0;
    // Account 1 tries to transfer 4 ether
    /// #sender: account-1 (sender is account at index '1')
    /// #value: 4000000000000000000
    function TransferMoreThanBalance() public {
        address payable userP2 = payable(user2);
        try TestSystem.TransferEth(userP2,4000000000000000000) {
       // {
           conter = 1;
       // }
        }
       catch Error(string memory reason)
        {
            Assert.equal(reason,string("Insufficient Funds"),"It is not giving the right error message");
        }
        Assert.equal(conter, 0,"It is allowing the user to transfer more than his bank balance.");     
    }


    // If this reverts, it implies that you are storing a negative value in a unit integer in your code!
    // Currently there are no funds availavle for loans in the bank.
    uint public counter = 0;
    /// #sender: account-1 (sender is account at index '1') 
    /// #value: 1000000000000000000
    function LoanWithNoFunds() public { 
        try TestSystem.TakeLoan(1000000000000000000) {
            counter = 1;
        }
        catch Error(string memory reason)
        {
            Assert.equal(reason,string("Insufficient Loan Funds"),"It is not giving the right error message");
        }
        Assert.equal(counter, 0,"You are giving out loans more than the funds available in the bank! ");     
    }

    // Now we have 10 ethers to give out loans
    /// #value: 10000000000000000000
    /// #sender: account-0 (sender is account at index '0')
    function checkLoanFund() public payable {
        TestSystem.depositTopUp{value:10000000000000000000}();        
    }

    // account 1 has 2 ethers ~ a loan limit of 4 ethers. 
    // it will try to take a loan of 5 ethers ~ this should be reverted with "loan limit exceeded"
    uint public cr = 0;
    /// #sender: account-1 (sender is account at index '1') 
    /// #value: 5000000000000000000
    function LoanLimitExceeded() public { 
        try TestSystem.TakeLoan(5000000000000000000) {
            cr = 1;
        }
        catch Error(string memory reason)
        {
            Assert.equal(reason,string("Loan Limit Exceeded"),"It is not giving the right error message");
        }
        Assert.equal(cr, 0,"You are giving out loans more than the user limit ");     
    }

    uint public cer = 0;
    /// #sender: account-1 (sender is account at index '1') 
    /// #value: 5000000000000000000
    function TryingToReturnWithoutTakingALoan() public { 
        try TestSystem.returnLoan{value:5000000000000000000}() {
            cer = 1;
        }
        catch Error(string memory reason)
        {
            Assert.equal(reason,string("No Loan"),"It is not giving the right error message");
        }
        Assert.equal(cer, 0,"It is allowing users with no loans to return loan.");     
    }


    // user 1 has a balance of 2 ethers in the bank - he asks for a loan of 1 ether
    // user 1, asks for a loan of 1 ether funds in the bank
    uint public orignalBalance = 0;
     uint public BalanceAfterLoan = 0;
    /// #sender: account-1 (sender is account at index '1') 
    function User1TakesLoan() public { 
        orignalBalance = user1.balance;
        TestSystem.TakeLoan(1000000000000000000);  
        BalanceAfterLoan = user1.balance;   
    }

    /// #sender: account-1 (sender is account at index '1')
    function CheckingLoanTransferred() public {
        uint loantaken = TestSystem.InquireLoan();
        Assert.equal(loantaken, uint(1000000000000000000), "Wrong Loan Record");
        Assert.equal(loantaken, uint(BalanceAfterLoan-orignalBalance), "Wrong Last Name");   
    }

    // USER 1 tries to pay back more - it should return "Owed amount exceeded"
    /// #sender: account-1 (sender is account at index '1') 
    /// #value: 5000000000000000000
    function TryingToReturnMoreThanLoanAmount() public { 
        try TestSystem.returnLoan{value:5000000000000000000}() {
            cer = 1;
        }
        catch Error(string memory reason)
        {
            Assert.equal(reason,string("Owed Amount Exceeded"),"It is not giving the right error message");
        }
        Assert.equal(cer, 0,"It is allowing users with no loans to return loan.");     
    }
}   