// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Ballot {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        string name; // Changed from bytes32 to string for better readability
        uint voteCount;
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    // 🔹 Constructor initializes the contract with proposal names
    constructor(string[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // 🔹 Function to grant voting rights
    function giveRightToVote(address voter) external {
        require(msg.sender == chairperson, "Only chairperson can give voting rights.");
        require(!voters[voter].voted, "Voter has already voted.");
        require(voters[voter].weight == 0, "Voter already has voting rights.");

        voters[voter].weight = 1;
    }

    // 🔹 Function to delegate vote to another voter
    function delegate(address to) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight > 0, "You have no right to vote.");
        require(!sender.voted, "You have already voted.");
        require(to != msg.sender, "Self-delegation is not allowed.");

        // Avoid loops in delegation
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "Loop detected in delegation.");
        }

        Voter storage delegate_ = voters[to];
        require(delegate_.weight > 0, "Delegate has no voting rights.");

        sender.voted = true;
        sender.delegate = to;

        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    // 🔹 Function to vote for a proposal
    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight > 0, "You have no right to vote.");
        require(!sender.voted, "You have already voted.");
        require(proposal < proposals.length, "Invalid proposal index."); // ✅ Fixed invalid proposal index check

        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
    }

    // 🔹 Function to determine the winning proposal index
    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    // 🔹 Function to get the winner's name
    function winnerName() external view returns (string memory winnerName_) {
        require(proposals.length > 0, "No proposals available.");
        require(winningProposal() < proposals.length, "No votes cast yet."); //  Fixed potential failure

        winnerName_ = proposals[winningProposal()].name;
    }
}
