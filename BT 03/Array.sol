Solidity code:
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayExample {
    uint[] public numbers;

    function addNumber(uint _num) public {
        numbers.push(_num);
    }

    function getNumber(uint _index) public view returns (uint) {
        require(_index < numbers.length, "Index out of range");
        return numbers[_index];
    }

    function getAllNumbers() public view returns (uint[] memory) {
        return numbers;
    }

    function getLength() public view returns (uint) {
        return numbers.length;
    }
}
