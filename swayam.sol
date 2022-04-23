pragma solidity ^0.8.0;

contract Voting{
    
    // State Variables
    address electionCommission; //Check if address of election commission repr
    bool isVotingData; //is voting active or not
    address[] candidateData; //candidate data obj
    address[] citizenData; //citizen data obj
    address canWin; //Current leader in votes
    
    // citizen record
    struct citizen{
        address id;
        string assem;
        bool isVoting;
    }
    
    // candidate record
    struct candidate{
        address can_id;
        string name;
        string assem;
        bool verify;
    }
    
    // votes record
    struct votes{
        address candidate_id;
        address[] voterID;
        uint count;
    }

    // reference type
    mapping(address => citizen)voter;
    mapping(address => candidate)candi;
    mapping(address => votes)vote;
    
    // event to be emmited later
    event message(string msg);
    event winner(string msg,address id, uint votes);
    
    constructor(){
        electionCommission = msg.sender;
        isVotingData = false;
    }
   
    modifier onlyGov(){
        require (electionCommission == msg.sender, "Access Denied");
        _;
    }
    
    function register_voter(string memory _assem)public{
        require(electionCommission != msg.sender, "Election Commission CANNOT BE CITIZEN");
        voter[msg.sender].id = msg.sender;
        voter[msg.sender].assem = _assem;
        voter[msg.sender].isVoting = false;
        citizenData.push(msg.sender);
        emit message("Voter Registered Successfully");
    }
    
    function register_candiate( string memory _name, string memory _assem)public{
        require(electionCommission != msg.sender, "Election Commission CANNOT BE CANDIDATE");
        candi[msg.sender].can_id = msg.sender;
        candi[msg.sender].name = _name;
        candi[msg.sender].assem = _assem;
        candi[msg.sender].verify = false;
        emit message("Candiate Registered Successfully");
        candidateData.push(msg.sender);
    }
    
    function verifyCandidate(address _can_id)public onlyGov{
        candi[_can_id].verify = true;
        emit message("Candiate Verified Successfully");
    }
    
    function startVoting() public onlyGov{
        require(isVotingData==false,"Voting Process is already STARTED");
        isVotingData = true;
        emit message("Voting process started");
    }
    
    function stopVoting() public onlyGov{
        require(isVotingData==true,"Voting Process is already STOPED");
        isVotingData = false;
    }
    
    function voteNow(address _can_id)public{
        require(voter[msg.sender].isVoting == false,"Candidate Already Voted");
        require(voter[msg.sender].id == msg.sender,"Voter Not Registered");
        vote[_can_id].candidate_id = _can_id;
        vote[_can_id].count +=1 ;       
        voter[_can_id].isVoting = true;
        }
    
    
    function countVotes() public onlyGov{
         uint i=0;
         uint high = 0;
         uint prev_temp_counting = 0;
         uint size = candidateData.length;
         for(i=0;i<size;i++){
             high = vote[candidateData[i]].count;
             if(high>prev_temp_counting){
                 canWin = candidateData[i];
             }
             else{
                 prev_temp_counting = high;
             }
         }
        
        emit winner("winner", canWin, high);
    }
    
    function viewCandiate(address _can_id) public view returns(address,string memory,string memory,bool){
        return(candi[_can_id].can_id,candi[_can_id].name,candi[_can_id].assem,candi[_can_id].verify);
    }
    
}
