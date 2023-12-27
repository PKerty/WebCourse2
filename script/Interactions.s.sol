//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";

import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

import {FundMe} from "../src/FundMe.sol";


contracts FundFundMe is Script {

    uint256 constant SEND_VALUE = 0.01 ether;
    function run() external {
        address deployAddress = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(deployAddress);
    }   
    function FundFundMe(address mostRecentDeploy) public {
        vm.startBroadcast()
        FundMe(payable(mostRecentDeploy)).fund{
            value: SEND_VALUE
        }();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }
}
contracts WithdrawFundMe is Script {
    
}
