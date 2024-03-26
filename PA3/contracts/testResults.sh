node compileDoubleAuction.js
contractAddress=$(node deployDoubleAuction.js)

echo "Your contract Address is: $contractAddress"

totalMarks=100;
YourMarks=0;

LengthIsCorrect=0;

output=$(node addSeller.js 5 5 0);
echo $output
output=($output)
Address0=${output[-1]}
Length0=${#Address0}

output=$(node addSeller.js 2 2 1);
echo $output
output=($output)
Address1=${output[-1]}

output=$(node addSeller.js 3 3 2);
echo $output
output=($output)
Address2=${output[-1]}

output=$(node addSeller.js 40 40 3);
echo $output
output=($output)
Address3=${output[-1]}


output=$(node addSeller.js 1 1 4);
echo $output
output=($output)
Address4=${output[-1]}
Length4=${#Address4}


output=$(node addBuyers.js 9 9 5);
echo $output
output=($output)
Address5=${output[-1]}

output=$(node addBuyers.js 7 7 6);
echo $output
output=($output)
Address6=${output[-1]}

output=$(node addBuyers.js 8 8 7);
echo $output
output=($output)
Address7=${output[-1]}
Length7=${#Address7}

output=$(node addBuyers.js 6 6 8);
echo $output
output=($output)
Address8=${output[-1]}

output=$(node addBuyers.js 10 10 9);
echo $output
output=($output)
Address9=${output[-1]}

output=$(node addBuyers.js 100 100 0);
echo $output
output=($output)
Address0=${output[-1]}

output=$(node addBuyers.js 100 100 6);
echo $output
output=($output)
Address6=${output[-1]}

output=$(node addSeller.js 1 1 8);
echo $output
output=($output)
Address8=${output[-1]}

totalLengths=$(($Length0 + $Length4 + $Length7));
if(( $totalLengths == 126))
then
	echo "addBuyer and addSeller seem to be fine";
	YourMarks=$(($YourMarks+20))
else
	echo "addBuyer and addSeller are outputting incorrectly"
fi
echo "Marks: $YourMarks/100"
resultOutput1=$(node getResults.js);
echo $resultOutput1
if [ -z "$resultOutput1" ];
then
	YourMarks=$(($YourMarks+5))
else
	echo "getResults is outputting incorrectly";
fi

DAoutput1=$(node DoubleAuction.js)

DAoutput2=$(node DoubleAuction.js)

if [[ "$DAoutput1" == "Double Auction Successful" && "$DAoutput2" == "Double Auction not Successful" ]];
then
	echo "DoubleAuction.js seems to be fine"
	YourMarks=$(($YourMarks+15))
else
	echo "DoubleAuction.js is NOT working as expected"
fi

echo "Marks: $YourMarks/100"

resultOutput2=$(node getResults.js);
resultOutput2=$(echo $resultOutput2)

actualResult="index sellAddresses buyAddresses C Q 1 $Address4 $Address9 6 1 2 $Address1 $Address5 6 2 3 $Address2 $Address7 6 3 4 $Address0 $Address6 6 5";

echo $resultOutput2
echo $actualResult

if [[ "$resultOutput2" == "$actualResult" ]];
then
	echo "getResults.js is fine and the DoubleAuction algorithm is implemented correctly"
	YourMarks=$(($YourMarks+60))
else
	echo "either getResults.js is not formatting the output correctly or the Double Auction algorithm is not implemented according to the handout"
fi
echo "Marks: $YourMarks/100"

