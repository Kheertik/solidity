// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract ProposalContract {

    address owner; 
    uint256 private counter;
    address[] private voted_addresses;

    struct Proposal {
        string title;
        string description;
        uint256 approve;
        uint256 reject;
        uint256 pass;
        uint256 total_vote_to_end;
        bool current_state;
        bool is_active;
    }

    mapping (uint256 => Proposal) proposal_history;

    constructor(){
        owner = msg.sender;
        voted_addresses.push(msg.sender);
    }

    modifier only_owner() {
        require(owner == msg.sender,  "You have to be a sender to create a contract!");
        _;
    }

    modifier active() {
        require(proposal_history[counter].is_active == true, "The proposal is not active");
        _;
    }

    modifier new_voter(address _address){
        require(!is_voted(_address), "Address has already voted.");
        _;
    }

    function set_owner(address new_owner) external only_owner {
        owner = new_owner;
    }

    function create(string calldata _title, string calldata _description, uint256 _total_vote_to_end) external only_owner {
        counter += 1;
        proposal_history[counter] = Proposal(_title, _description, 0, 0, 0, _total_vote_to_end, false, true);
    }
  
    function vote(uint8 choice) external {
        Proposal storage proposal = proposal_history[counter];
        
         if (choice == 1) {
            proposal.approve += 1 ;
        } else if (choice == 2) {
            proposal.reject += 1;
        } else if (choice == 0) {
            proposal.pass += 1;
        }

        voted_addresses.push(msg.sender);
        uint256 total_vote = proposal.approve + proposal.reject + proposal.pass;
    
        proposal.current_state = calculateCurrentState();

        if ((proposal.total_vote_to_end - total_vote == 0) && (choice == 1  || choice == 2 || choice == 3)){
            proposal.is_active = false;
            voted_addresses = [owner];
        }
    }

    function calculateCurrentState() private view returns (bool) {
        Proposal storage proposal = proposal_history[counter];

        uint256 approve = proposal.approve;
        uint256 reject = proposal.reject;
        uint256 pass = proposal.pass;

        if (proposal.pass % 2 == 1){
            pass  += 1;
        }

        pass = pass / 2;

        if (approve > reject + pass){
            return true;
        } else {
            return false;
        }
    }

    function terminate_proposal() external only_owner active {
        proposal_history[counter].is_active = false;
    }

    function is_voted(address _address) public view returns (bool) {
        for (uint i = 0; i < voted_addresses.length; i++){
            if (voted_addresses[i] == _address){
                return true;
            }
        }
        return false;
    }

    function getCurrentProposal() external view returns (Proposal memory) {
        return proposal_history[counter];
    }

    function getProposal(uint256 number) external view returns (Proposal memory) {
        return proposal_history[number];
    }
}   
