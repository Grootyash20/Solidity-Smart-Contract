// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Project{ 

    struct Proposal{

    uint id;
    string name;
    string content;
    uint amount; 
    address payable receipient;
    uint votes;
    bool isExecuted;
    
}

    struct Course{

        string topic;
        uint no_of_videos;
        uint price;
        uint validity;
        uint rating;
        string review;
        address owner;
        uint course_no;
        uint received_amount;

    }

    struct Question{
        
        string question;
        string answer;
    }
    
    mapping(address => bool) public isValidator;
    mapping(address => bool) public users;
    mapping(address => uint) public noOfTokens;  
    mapping(address => mapping(uint => bool)) public isVoted;
    mapping(uint => Proposal) proposals;
    mapping(address => Course) courses;
    //mapping(address => bool) coursecreator;
    mapping(address => Course[]) coursebought;
    mapping(address => Question[]) questions;

    uint totaltokens;
    uint availableFunds;
    uint poolingTimeEnd;
    uint nextproposalId;
    //uint nextcourseId;
    uint quorum;
    address admin;
    address[] userArray;
    address[] coursecreators;
    address[] questioners;

    address[] ValidatorsList;


    constructor(uint _poolingTimeEnd, uint _quorum){
        require(_quorum>0 && _quorum<100, "Not Valid Value");

        poolingTimeEnd = block.timestamp + _poolingTimeEnd;
        quorum = _quorum;
        admin = msg.sender; 
    }

    function askQuestion(address questioner, string memory question) public{
        require(users[questioner] == true, "You are not a registered user to the system, Please register yourself");

        questions[questioner].push(Question(
            question,
            "no answer yet"
        ));
        questioners.push(questioner);
    }

    function returnaskedQuestions(address questioner) public view returns(Question[] memory){
        require(users[questioner] == true, "You are not a registered user to the system, Please register yourself");

        return questions[questioner];
    }

    function solveQuestion(address questioner, uint id, string memory answer) public {
        require(users[questioner] == true, "You are not a registered user to the system, Please register yourself");

        questions[questioner][id].answer = answer;

    }
    
    event Message(string message);
    
    function satisfied(bool value, address solver) public payable{
        for(uint i=0;i<questioners.length;i++){
            require(questioners[i] == msg.sender, "You are not the one who asked the question");
        }
        if(value == true){
            payable(solver).transfer(msg.value);
            emit Message("Successful Transfer once solved");
        }
        else{
            emit Message("Not Satisfied with the answer thus Unsuccesful");
        }
    }


    function addcourse(address owner, string memory topic, uint no_of_videos, uint price, uint validity, uint course_no) public  {
        require(users[owner] == true, "You are not a registred user, Register Yourself and then try to launch a course");

        courses[owner] = Course(
            topic,
            no_of_videos,
            price,
            validity,
            0,
            "Not yet reviewed",
            owner,
            course_no,
            0
        );
        coursecreators.push(owner);

    }

    event pushtologfile(address b, address c, uint amount);

    function coursebuy(address buyer, address creatorofcourse) public payable{
        require(users[buyer] == true, "You are not a registered user to the system, Please register yourself");
        require(creatorofcourse != buyer , "You cannot buy your own course");
        require(msg.value == courses[creatorofcourse].price, "Please pay the given amount");

        coursebought[buyer].push(courses[creatorofcourse]);
        payable(creatorofcourse).transfer(courses[creatorofcourse].price);
        courses[creatorofcourse].received_amount = msg.value;
        emit pushtologfile(buyer, creatorofcourse, msg.value); 

    }

    function returnlistedcourse(address creator) public view returns(Course memory){
        return courses[creator];
    }

    function returnboughtcourses(address buyer) public view returns(Course[] memory){
        return coursebought[buyer];
    }

    function returncoursescreators() public view returns(address[] memory){
        return coursecreators;
    }


    function returnQuorum() public view returns(uint){
        return quorum;
    }

    function returnPoolingTimeEnd() public view returns(uint){
        return poolingTimeEnd;
    }

    modifier onlyValidator(){
        require(isValidator[msg.sender] == true, "You are not a Validator");
        _;
    }

    modifier onlyAdmin(){
        require(admin == msg.sender, "You are not the Admin");
        _;
    }


    function returnAdmin() public view returns(address){
        return admin;
    }


    function investment() public payable{
        require(poolingTimeEnd >= block.timestamp, "Pooling time ended");
        require(msg.value > 0, "Pool enough ether");

        isValidator[msg.sender] = true;
        noOfTokens[msg.sender] += msg.value;
        totaltokens += msg.value;
        availableFunds += msg.value;
        ValidatorsList.push(msg.sender);
    }

    function returnTotalTokens() public view returns(uint){
        return totaltokens;
    }

    function userregister(address useraddress) public{
        users[useraddress] = true;
        userArray.push(useraddress);

    } 

    function returnUserArray() public view returns(address[] memory){

        return userArray;
    }

    function redeemtoken(uint amount) public onlyValidator{
        require(noOfTokens[msg.sender] >= amount, "You can't redeem more than you hold");
        require(availableFunds >= amount, "Not enough funds in the framework to liquidate your tokens");

        noOfTokens[msg.sender] -= amount;
        if(noOfTokens[msg.sender] == 0){
            isValidator[msg.sender] = false;
        }
        availableFunds -= amount;
        payable(msg.sender).transfer(amount);
    }

    function transfertoken(uint amount, address receiver) public onlyValidator{
        require(noOfTokens[msg.sender] > amount, "You can't transfer more than you have");

        noOfTokens[msg.sender] -= amount;
        if(noOfTokens[msg.sender] == 0){
            isValidator[msg.sender] = false;
        }

        noOfTokens[receiver] += amount;
        isValidator[receiver] = true;
        ValidatorsList.push(receiver);

    }

    function createProposal(string calldata content, string calldata name, uint amount, address payable receipient) public{
        require(users[receipient] == true, "You are not a registered user");
        require(availableFunds >= amount, "Not Enough funds");

        proposals[nextproposalId] = Proposal(
            nextproposalId,
            name,
            content,
            amount,
            receipient,
            0,
            false
        );
        nextproposalId++;
    }

    function voteProposal(uint proposalId) public onlyValidator{
        Proposal storage proposal = proposals[proposalId];
        require(isVoted[msg.sender][proposalId] == false, "You can only vote once to a proposal");
        require(proposal.isExecuted == false, "Proposal is already executed");

        isVoted[msg.sender][proposalId] = true;
        proposal.votes += noOfTokens[msg.sender];
    }

    function executeProposal(uint proposalId) public onlyAdmin{
        Proposal storage proposal = proposals[proposalId];
        require(((proposal.votes*100)/totaltokens) > quorum, "You dont have the majority, content can't be published");

        proposal.isExecuted = true;
        availableFunds -= proposal.amount;
        _transfer(proposal.amount, proposal.receipient);
        contentpush(proposalId);

    }

    function returnAvailableFunds() public view returns(uint){
        return availableFunds;
    }

    function _transfer(uint amount, address payable receipient) private{
        receipient.transfer(amount);
    }

    function ProposalList() public view returns(Proposal[] memory){
        Proposal[] memory arr = new Proposal[](nextproposalId);
        for(uint i=0;i<nextproposalId;i++){
            arr[i] = proposals[i];
        }
        return arr;
    }

    event pushtologfile2(uint id, string content, uint amount);
    
    function contentpush(uint proposalId) private{
        Proposal storage proposal = proposals[proposalId];
        require(proposal.isExecuted == true, "Proposal hasn't been executed, cant be pushed to log file");

        emit pushtologfile2(proposal.id,proposal.content,proposal.amount);
    }  

    function returnValidatorsList() public view returns(address[] memory){
        return ValidatorsList;
    }

    function returnNextProposalId() public view returns(uint){
        return nextproposalId;
    }

}  


