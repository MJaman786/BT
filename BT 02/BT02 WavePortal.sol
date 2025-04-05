// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;


    event NewWave(address indexed from, uint256 timestamp, string message);


    function wave(string memory _message) public {
        totalWaves += 1;
        console.log("%s has waved w/ message %s", msg.sender, _message);
        emit NewWave(msg.sender, block.timestamp, _message);
    }


    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}
