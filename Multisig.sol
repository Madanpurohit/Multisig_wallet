pragma solidity ^0.7.5;
pragma abicoder v2;
contract Multisig{
    address[] public Owners;
    uint limit;
    struct Transfer{
        uint ammount;
        address payable receiver;
        uint capprovals;
        bool hasbeensent;
        uint id;
    }
    Transfer[] transferRequest;
    mapping(address=>mapping(uint=>bool)) approvels;
    constructor(address[] memory _owners,uint _limit){
        Owners=_owners;
        limit=_limit;
    }
    modifier onlyOwner{
        bool flag=false;
        for(uint i=0;i<Owners.length;i++) if(Owners[i]==msg.sender){flag=true;}
        require(flag==true,"only owner is allowed");
        _;
    }
    function deposit() public payable{}
    function createTransfer(uint _ammount,address payable _receiver) public onlyOwner{
        transferRequest.push(Transfer(_ammount,_receiver,0,false,transferRequest.length));
    }
    function approve(uint _id) public onlyOwner{
        require(approvels[msg.sender][_id]==false);
        require(transferRequest[_id].hasbeensent==false);
        approvels[msg.sender][_id]=true;
        transferRequest[_id].capprovals+=1;
        if(transferRequest[_id].capprovals>=limit){
            transferRequest[_id].hasbeensent=true;
            transferRequest[_id].receiver.transfer(transferRequest[_id].ammount);
        }
    }
    function getTransferRequest() public view returns(Transfer[] memory){
        return transferRequest;
    }
    
}
