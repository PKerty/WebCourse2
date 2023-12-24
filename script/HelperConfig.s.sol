// 1. Deploy mocks when we are on a local anvil chain
// 2. Keep track of contract address across different chains

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

import {MockV3Aggregator} from "@test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {


    struct NetworkConfig {
        address priceFeed;
    }

    uint8 public constant DECIMALS= 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    NetworkConfig public activeConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeConfig = getSepoliaEthConfig();
        } else {
            activeConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        return NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
    }

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory) {
        if(activeConfig.priceFeed != address(0)) {
            return activeConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        return NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
    }
}