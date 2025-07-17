// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserProfileRegistry {

    
    struct User {
        string name;
        uint age;
        string location;
        uint registrationTimestamp;
        bool isRegistered;
    }

    // Mapping to store each user's profile using their wallet address
    mapping(address => User) private users;


    function register(string calldata _name, uint _age, string calldata _location) external {
        // Check if the user is already registered
        require(!users[msg.sender].isRegistered, "You have already registered");

        // Create a new User and store it in the mapping
        users[msg.sender] = User({
            name: _name,
            age: _age,
            location: _location,
            registrationTimestamp: block.timestamp,
            isRegistered: true
        });
    }

    function updateProfile(string calldata _name, uint _age, string calldata _location) external {
        // Make sure the user is already registered
        require(users[msg.sender].isRegistered, "You are not registered yet");

        // Update the user's profile
        users[msg.sender].name = _name;
        users[msg.sender].age = _age;
        users[msg.sender].location = _location;
        // We do not update the registration timestamp
    }

    function getProfile(address _userAddress) external view returns (
        string memory name,
        uint age,
        string memory location,
        uint registrationTimestamp,
        bool isRegistered
    ) {
        User memory user = users[_userAddress];

        return (
            user.name,
            user.age,
            user.location,
            user.registrationTimestamp,
            user.isRegistered
        );
    }
}
