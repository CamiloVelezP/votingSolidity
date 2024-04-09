// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
  constructor() {
        owner = msg.sender;
        startTime = block.timestamp;
        endTime = startTime + 3 days; 
    }

    struct Proposal {
        string name;
        uint256 voteCount;
        bool proposalExist;
    }

    mapping(address => bool) private whitelist;
    mapping(string => Proposal) private proposals;
    mapping(address => bool) private hasVoted;

    address private owner;
    uint256 private startTime;
    uint256 private endTime;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can do this");
        _;
    }

    modifier onlyWhitelisted() {
        require(whitelist[msg.sender], "Address is not valid to vote");
        _;
    }

    modifier onlyDuringVotingPeriod() {
        require(block.timestamp <= endTime, "Voting period has already ended");
        _;
    }

    function addToWhitelist(address voterAddress) public onlyOwner {
        whitelist[voterAddress] = true;
    }

    function removeFromWhitelist(address voterAddress) public onlyOwner {
        delete whitelist[voterAddress];
    }

    function addProposal(string memory propName) public onlyOwner {
        require(!proposals[propName].proposalExist, "Proposal already exists");
        proposals[propName] = Proposal(propName, 0, true);
    }

    function removeProposal(string memory propName) public onlyOwner {
        require(proposals[propName].proposalExist, "Proposal does not exist");
        delete proposals[propName];
    }

    function isValidToVote(address voterAddress) public view onlyWhitelisted returns(bool){ 
        require(!hasVoted[voterAddress], "Address is valid but has already voted");
        return true;
    }

    function vote(string memory propName) public onlyDuringVotingPeriod {
        require(isValidToVote(msg.sender), "Address is not valid to vote");
        require(proposals[propName].proposalExist, "Proposal does not exist");
        proposals[propName].voteCount++;
        hasVoted[msg.sender] = true;
    }

    function endVotingPeriod() public onlyOwner onlyDuringVotingPeriod{
        endTime = block.timestamp;
    }

    function isVotingPeriod() public view returns (bool) {
        return block.timestamp <= endTime;
    }

    function getProposalVoteCount(string memory propName) public view returns (uint256) {
        return proposals[propName].voteCount;
    }
}