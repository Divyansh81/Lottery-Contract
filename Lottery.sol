// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }

    function enter() public payable {
        require(msg.value > .01 ether, "Minimum contribution is 0.01 ether");
        players.push(msg.sender);
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    function pickWinner() public onlyManager {
        require(players.length > 0, "No players participated in the lottery");

        uint256 index = random() % players.length;
        address winner = players[index];
        address payable winnerPayable = payable(winner);

        winnerPayable.transfer(address(this).balance);

        // Reset the players array for the next round
        players = new address[](0);
    }
}
