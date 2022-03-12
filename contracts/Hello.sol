// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract Hello {
    //POJO for Admin
    struct Admin {
        string adminName;
        string adminEmail;
        address adminAddress;
    }

     //POJO for Donor
    struct Donor{
        string donorName;
        address donorAddress;
        string donorEmail;
        uint participatedCount;
        address[] participatedProjects;
    }

    // POJO for Benifactor
    struct Benifactor{
        string benifactorName;
        address benifactorAddress;
        string benifactorEmail;
    }

    //POJO for Charity Organisation
    struct CharityProject{
        string projectName;
        address createrAddress;
        string projectDescription;
        uint amountRequire;
        bool isCompleted;
        uint amountGot;
        bool isApproved;

    }

    //Organiser / Admin (Who created this Smart Contract)
    Admin private admin;
    
    mapping(address => Donor) public donors;
    mapping(address => Benifactor) public benifactors;
    mapping(uint => CharityProject) public charityProjects;
    uint public totalProjects;

    //Constructor => Set's Admin only once at starting

    constructor () public {
        admin = Admin({
            adminName: "Abhijeet Khamkar",
            adminEmail: "abhijeetkhamkar30@gmail.com",
            adminAddress: msg.sender
        });

        totalProjects = 0;
        addNewDonor("d1", "d1.in");
    }

    // Add new Benifactor
    function addNewBenifactor(string memory name, string memory email) public {
        Benifactor memory newBenifactor = Benifactor({
            benifactorName: name,
            benifactorAddress: msg.sender,
            benifactorEmail: email
        });

        benifactors[msg.sender] = newBenifactor;
        //Emmit Event
    }  

    //Login Benifactor
    // function loginBenifactor() public view returns (Benifactor memory) {
    //     return benifactors[msg.sender];
    //     contract.methods.benifactors(address);
    //     itn part = contract.methods.donors(address).participatedCount;
    //     for(int i=0; i<part)  contract.methods.donors(address).participated(i);
    // }


    //Add new Donor
    function addNewDonor(string memory name, string memory email) public {

        Donor memory newDonor = Donor({
            donorName: name,
            donorAddress: msg.sender,
            donorEmail: email,
            participatedCount: 0,
            participatedProjects: new address[](0)
        });

        donors[msg.sender] = newDonor;
        //Emmit Event
    } 

    
    //Add new Project
    function addNewProject(string memory name, string memory desc, uint amtReq) public {

        CharityProject memory newProject = CharityProject({
            projectName : name,
            createrAddress : msg.sender,
            projectDescription : desc,
            amountRequire : amtReq,
            isCompleted: false,
            amountGot: 0,
            isApproved: false
        });

        totalProjects += 1;
        charityProjects[totalProjects] = newProject;
        //Emmit Event
    } 

}
