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
        uint projectId;
        string projectName;
        address payable createrAddress;
        string projectDescription;
        uint amountRequire;
        bool isCompleted;
        uint amountGot;
        bool isApproved;
    }

    //Organiser / Admin (Who created this Smart Contract)
    Admin public admin;
    
    mapping(address => Donor) public donors;
    
    mapping(address => Benifactor) public benifactors;

    mapping(uint => CharityProject) public charityProjects;
    
    uint public totalProjects = 0;

    //Constructor => Set's Admin only once at starting
    constructor () public {
        admin = Admin({
            adminName: "admin",
            adminEmail: "admin@charitychain.in",
            adminAddress: msg.sender
        });

        totalProjects = 1;

        CharityProject memory newProject = CharityProject({
            projectId: totalProjects,
            projectName : "name",
            createrAddress : msg.sender,
            projectDescription : "desc",
            amountRequire : 0,
            isCompleted: false,
            amountGot: 0,
            isApproved: false
        });

        charityProjects[totalProjects] = newProject;
    }

    event newBenifactorAdded (
        string benifactorName,
        address payable benifactorAddress,
        string benifactorEmail
    );

    event newDonorAdded (
        string donorName,
        address donorAddress,
        string donorEmail
    );

    event newProjectAdded (
        uint projectId,
        string projectName,
        address payable createrAddress,
        string projectDescription,
        uint amountRequire,
        bool isCompleted,
        uint amountGot,
        bool isApproved
    );

    event projectApproved (
        uint projectId,
        string projectName,
        address createrAddress,
        string projectDescription,
        uint amountRequire,
        bool isCompleted,
        uint amountGot,
        bool isApproved
    );

    event returnMessage(
        bool status,
        string message
    );

    function getAdmin() public view returns (address) {
        return admin.adminAddress;
    }

    // Add new Benifactor
    function addNewBenifactor(string memory name, string memory email) public {
        if(keccak256(abi.encodePacked(benifactors[msg.sender].benifactorName)) 
        != keccak256(abi.encodePacked(""))) {
            emit returnMessage(false, "User with this address already exist");
            return;
        } 

        Benifactor memory newBenifactor = Benifactor({
            benifactorName: name,
            benifactorAddress: msg.sender,
            benifactorEmail: email
        });

        benifactors[msg.sender] = newBenifactor;
        emit newBenifactorAdded(name, msg.sender, email);
    }  


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
        emit newDonorAdded(name, msg.sender, email);
    } 

    
    //Add new Project
    function addNewProject(string memory name, string memory desc, uint amtReq) public {
        totalProjects += 1;

        CharityProject memory newProject = CharityProject({
            projectId: totalProjects,
            projectName : name,
            createrAddress : msg.sender,
            projectDescription : desc,
            amountRequire : amtReq,
            isCompleted: false,
            amountGot: 0,
            isApproved: false
        });

        charityProjects[totalProjects] = newProject;
        emit newProjectAdded(totalProjects, name, msg.sender, desc, amtReq, false, 0, false);
    }



    function approvProject(uint id) public {

        CharityProject memory newProject = CharityProject({
            projectId: id,
            projectName : charityProjects[id].projectName,
            createrAddress : charityProjects[id].createrAddress,
            projectDescription : charityProjects[id].projectDescription,
            amountRequire : charityProjects[id].amountRequire,
            isCompleted: charityProjects[id].isCompleted,
            amountGot: charityProjects[id].amountGot,
            isApproved: true
        });

        charityProjects[id] = newProject;

        emit projectApproved(id, charityProjects[id].projectName, charityProjects[id].createrAddress,
         charityProjects[id].projectDescription, charityProjects[id].amountRequire, charityProjects[id].isCompleted, charityProjects[id].amountGot, true);
    }


    function donateEther(address payable to, uint id) public payable {
        
        to.transfer(msg.value);
        
        uint eth = msg.value / 1000000000000000000;
        uint amtGot = eth + charityProjects[id].amountGot;
        bool isCom = amtGot == charityProjects[id].amountRequire;

        CharityProject memory newProject = CharityProject({
            projectId: id,
            projectName : charityProjects[id].projectName,
            createrAddress : charityProjects[id].createrAddress,
            projectDescription : charityProjects[id].projectDescription,
            amountRequire : charityProjects[id].amountRequire,
            isCompleted: isCom,
            amountGot: amtGot,
            isApproved: true
        });

        charityProjects[id] = newProject;
    }

    function donate(uint pId) public payable {
        charityProjects[pId].createrAddress.transfer(msg.value);
    }


}