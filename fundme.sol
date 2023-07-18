//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "./priceConverter.sol";

contract FundMe{
   using PriceConverter for uint256;   
   uint256 minimumUsd = 50 * 1e18;
   address[] public funders;
   mapping(address => uint256) public addressToAmountFunded;
   address public owner;

   constructor() {
       owner = msg.sender;
   }
   function fund() public payable {
      require(msg.value.getConversionRate() >= 50 * 1e18, "Didn't send enough!");
      funders.push(msg.sender); //to collect all the funders in an array!
      addressToAmountFunded[msg.sender] = msg.value;
 
   }

   function withdraw() public onlyOwner {
    for(uint256 fundersIndex = 0; fundersIndex < funders.length; fundersIndex++){
        // loop through all the address
           address funder = funders[fundersIndex];
           addressToAmountFunded[funder] = 0; 
    }
      funders = new address[](0);
      (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
      require(callSuccess, "Call failed!"); 
   }

   modifier onlyOwner{
       require(msg.sender == owner, "caller is not owner!");
       _;

   }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }


 }
