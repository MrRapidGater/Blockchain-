// SPDX-License-Identifier: HF
pragma solidity ^0.8.1;

/*
Feel free to create your own functions and interact with them in JavaScript
DO NOT CHANGE THE FUNCTION DEFINITIONS OF ANY OF THE FUNCTIONS ALREADY DEFINED BELOW

THE ONLY FUNCTION YOU ARE ALLOWED THE CHANGE THE DEFINITION OF IS getHistory().
You will probably need to change that.
*/

contract DoubleAuction {
    uint private constant maxSize = 20; //maximum number of bids
    uint private constant AuctionInterval = 30; //time in seconds. Contract shouldn't be called faster than this

    struct Bid {
        address bidder;
        uint quantity;
        uint price;
        bool exists;
    }

    Bid[] public buyBids;
    Bid[] public sellBids;
    uint private lastAuctionTime;

    struct Result {
        address seller;
        address buyer;
        uint C;
        uint Q;
    }

    Result[] results;

    mapping(address => Bid) public hasPlacedBid;

    function addBuyer(uint quantity, uint price) public {
        require(hasPlacedBid[msg.sender].exists == false, "Failure");
        require(msg.sender.balance > quantity * price, "Insufficient funds");

        Bid memory temp = Bid(msg.sender, quantity, price, true);
        buyBids.push(temp);
        hasPlacedBid[msg.sender] = temp;
    }

    function addSeller(uint quantity, uint price) public {
        require(!hasPlacedBid[msg.sender].exists, "Bidder already exists");

        // require(quantity > 0, "Quantity must be greater than zero");
        Bid memory temp = Bid(msg.sender, quantity, price, true);
        sellBids.push(temp);
        hasPlacedBid[msg.sender] = temp;
    }

    function doubleAuction() public {
        require(
            block.timestamp >= lastAuctionTime + 30 seconds,
            "Double auction can only be called once every 30 seconds."
        );

        // Set last auction time
        lastAuctionTime = block.timestamp;

        // Bubble sort the buy and sell bids
        bool swapped;
        uint256 n = buyBids.length;
        do {
            swapped = false;
            for (uint256 i = 0; i < n - 1; i++) {
                if (buyBids[i].price < buyBids[i + 1].price) {
                    Bid memory temp = buyBids[i];
                    buyBids[i] = buyBids[i + 1];
                    buyBids[i + 1] = temp;
                    swapped = true;
                }
            }
            n--;
        } while (swapped);

        n = sellBids.length;
        do {
            swapped = false;
            for (uint256 i = 0; i < n - 1; i++) {
                if (sellBids[i].price > sellBids[i + 1].price) {
                    Bid memory temp = sellBids[i];
                    sellBids[i] = sellBids[i + 1];
                    sellBids[i + 1] = temp;
                    swapped = true;
                }
            }
            n--;
        } while (swapped);

        // Find the breakeven index
        uint256 k = 0;
        while (
            k < buyBids.length &&
            k < sellBids.length &&
            buyBids[k].price >= sellBids[k].price
        ) {
            k++;
        }

        // If no breakeven index is found, reject all bids
        require(k > 0, "Error");

        uint256 auctionPrice = (buyBids[k - 1].price + sellBids[k - 1].price) /
            2;

        for (uint i = 0; i < k; i++) {
            uint temp = 0;
            if (sellBids[i].quantity > buyBids[i].quantity) {
                temp = buyBids[i].quantity;
            } else {
                temp = sellBids[i].quantity;
            }

            results.push(
                Result(
                    sellBids[i].bidder,
                    buyBids[i].bidder,
                    auctionPrice,
                    temp
                )
            );
        }
    }

    function getResults() public view returns (Result[] memory) {
        return results;
    }
}
