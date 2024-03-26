// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../contracts/banking_rollnumber_contract.sol";
import "remix_accounts.sol";


contract OwnerTest{
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

        /// #sender: account-0 (sender is account at index '1')
    // This function is to test if the owner is prohibited to create an account & if it gives the right error     
    uint public errorCount = 0;
    function testOwnerAccountOpening() public  {
        try TestSystem.openAccount("humza","ikram") 
        {
            // Here the owner is calling this function, IF he is able to make an account than case fails.
            errorCount = 1;      
        }  catch Error(string memory reason)
        {
            // If the owner is unable to create an account, it comes here & the reason should be caught.
            // if the owner is unable to create an account, it will return the string reason which should be as in manual.
            Assert.equal(reason,string("Error, Owner Prohibited"),"Owner not giving the right error");
        }
        Assert.equal(errorCount, 0,"Error - Owner Can Also Create An Account");      
    } 


    /// #sender: account-0 (sender is account at index '1')
    // This function is to test if the owner is prohibited to create an account & if it gives the right error     
    uint public Ec = 0;
    function testOwnerAskingForLoan() public  {
        try TestSystem.TakeLoan(1000000000000000000)   
        {
            // Here the owner is calling this function, IF he is able to make an account than case fails.
            Ec = 1;      
        }  catch Error(string memory reason)
        {
            // If the owner is unable to create an account, it comes here & the reason should be caught.
            // if the owner is unable to create an account, it will return the string reason which should be as in manual.
            Assert.equal(reason,string("Error, Owner Prohibited"),"Owner not giving the right error in taking a loan");
        }
        Assert.equal(Ec, 0,"Error - Owner Can Also Take A Loan");
    }



    function testOwnerTransfer() public  {
        address payable userP2 = payable(user2);
        try TestSystem.TransferEth(userP2,5000000000000000000)
        {
            // Here the owner is calling this function, IF he is able to make an account than case fails.
            Ec = 1;      
        }  catch Error(string memory reason)
        {
            // If the owner is unable to create an account, it comes here & the reason should be caught.
            // if the owner is unable to create an account, it will return the string reason which should be as in manual.
            Assert.equal(reason,string("Error, Owner Prohibited"),"Owner not giving the right error in ether transfer!");
        }
        Assert.equal(Ec, 0,"Error - Owner Cannot Transfer Money");
    }

    function testOwnerForWithdrawal() public  {
        try TestSystem.withDraw(1000000000000000000)
        {
            // Here the owner is calling this function, IF he is able to make an account than case fails.
            Ec = 1;      
        }  catch Error(string memory reason)
        {
            // If the owner is unable to create an account, it comes here & the reason should be caught.
            // if the owner is unable to create an account, it will return the string reason which should be as in manual.
            Assert.equal(reason,string("Error, Owner Prohibited"),"Owner not giving the right error in withdrawal function.");
        }
        Assert.equal(Ec, 0,"Error - Owner Cannot Withdraw Money");
    }

    uint public c = 0;
    /// #sender: account-3 (sender is account at index '1')
    function UserWithNoAccountGettingDetails() public  {
        try TestSystem.getDetails()
        {
            // Here the owner is calling this function, IF he is able to make an account than case fails.
            c = 1;      
        }  catch Error(string memory reason)
        {
            // If the owner is unable to create an account, it comes here & the reason should be caught.
            // if the owner is unable to create an account, it will return the string reason which should be as in manual.
            Assert.equal(reason,string("No Account"),"Not giving the correct error");
        }
        Assert.equal(c, 0,"This should revert!");     
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

    /// #sender: account-1 (sender is account at index '1')
    function checkUser1Details() public {
        (uint balance2, string memory first_name2, string memory last_name2, uint loanAmount) = TestSystem.getDetails(); 
        Assert.equal(balance2, uint(0), "Wrong Balance");
        Assert.equal(first_name2, string("Zain"), "Wrong First Name");
        Assert.equal(last_name2, string("Nadeem"), "Wrong Last Name");   
        Assert.equal(loanAmount,0,"Wrong Loan Amount");
    }
   
    
    uint public Ct = 0;
    /// #sender: account-1 (sender is account at index '1')    
    function testExistingAccountOpening() public  {
        try TestSystem.openAccount("Zain","Nadeem") 
        {
            // Here the owner is calling this function, IF he is able to make an account than case fails.
            Ct = 1;      
        }  catch Error(string memory reason)
        {
            // If the owner is unable to create an account, it comes here & the reason should be caught.
            // if the owner is unable to create an account, it will return the string reason which should be as in manual.
            Assert.equal(reason,string("Account already exists"),"Not giving the right error");
        }
        Assert.equal(Ct, 0,"Error - Account Recreation Allowed");      
    } 
    
    uint public cnt = 0;
    /// #sender: account-3 (sender is account at index '1')
    /// #value: 10000000000000000000
    function UserWithNoAccountDepositing() public payable  {
        try TestSystem.depositAmount{value:10000000000000000000}()
        {
            // Here the owner is calling this function, IF he is able to make an account than case fails.
            cnt = 1;      
        }  catch Error(string memory reason)
        {
            // If the owner is unable to create an account, it comes here & the reason should be caught.
            // if the owner is unable to create an account, it will return the string reason which should be as in manual.
            Assert.equal(reason,string("No Account"),"Not giving the correct error");
        }
        Assert.equal(cnt, 0,"This should revert!");     
    } 

        uint public cntr = 0;
    /// #sender: account-3 (sender is account at index '1')
    /// #value: 10000000000000000000
    function UserWithNoAccountWithdrawing() public payable  {
        try TestSystem.withDraw(1000000000000000000)
        {
            // Here the owner is calling this function, IF he is able to make an account than case fails.
            cntr = 1;      
        }  catch Error(string memory reason)
        {
            // If the owner is unable to create an account, it comes here & the reason should be caught.
            // if the owner is unable to create an account, it will return the string reason which should be as in manual.
            Assert.equal(reason,string("No Account"),"Not giving the correct error");
        }
        Assert.equal(cntr, 0,"This should revert!");     
    } 

    uint public contr = 0;
    /// #sender: account-3 (sender is account at index '1')
    /// #value: 10000000000000000000
    function UserWithNoAccountReturningLoan() public payable  {
        try TestSystem.returnLoan{value:10000000000000000000}()
        {
            // Here the owner is calling this function, IF he is able to make an account than case fails.
            contr = 1;      
        }  catch Error(string memory reason)
        {
            // If the owner is unable to create an account, it comes here & the reason should be caught.
            // if the owner is unable to create an account, it will return the string reason which should be as in manual.
            Assert.equal(reason,string("No Account"),"Not giving the correct error");
        }
        Assert.equal(contr, 0,"This should revert!");     
    } 
}