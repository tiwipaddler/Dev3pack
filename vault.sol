// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library MathLib {
    function add(uint a, uint b) internal pure returns (uint) {
        return a + b;
    }

    function sub(uint a, uint b) internal pure returns (uint) {
        require(b <= a, "it should not be negative");
        return a - b;
    }
}

contract VaultBase {
    mapping(address => uint256) internal balances;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}


contract VaultManager is VaultBase {
    using MathLib for uint256;

    function deposit() public payable {
        require(msg.value > 0, "Cannot deposit 0 ETH");

        balances[msg.sender] = balances[msg.sender].add(msg.value);
        emit Deposited(msg.sender, msg.value);
    }
    // direct sending
    receive() external payable {
        require(msg.value > 0, "Cannot deposit 0 ETH");
        
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        emit Deposited(msg.sender, msg.value);
     }


    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdraw amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] = balances[msg.sender].sub(amount);
        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);
    }
}