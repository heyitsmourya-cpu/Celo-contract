
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Medichain
 * @dev A simple contract for immutable health report storage.
 * Only the deployer (owner) can add reports, but anyone can view them.
 */
contract Medichain {
    // A mapping to store the health reports.
    // Key: uint (Patient ID)
    // Value: string (The actual health report data)
    mapping(uint => string) private patientReports;

    // The address of the contract creator (owner).
    address private owner;

    // Event emitted when a new report is added.
    event ReportAdded(uint patientId, address indexed addedBy);

    // Modifier to restrict functions to only the owner.
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _; // Continue with the function execution.
    }

    /**
     * @dev The constructor runs only once when the contract is deployed.
     * It sets the deployer as the contract owner.
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Adds a new health report for a specific patient ID.
     * @dev This function can only be called by the contract owner.
     * @param _patientId The unique ID of the patient.
     * @param _reportData The actual health report data (e.g., a hash or JSON string).
     */
    function addReport(uint _patientId, string memory _reportData) public onlyOwner {
        // Prevent overwriting an existing report for immutability
        // We check if the existing data is an empty string (the default for a new slot)
        require(bytes(patientReports[_patientId]).length == 0, "Report for this ID already exists and cannot be overwritten.");

        patientReports[_patientId] = _reportData;

        // Emit an event for easy off-chain monitoring
        emit ReportAdded(_patientId, msg.sender);
    }

    /**
     * @notice Retrieves the health report for a specific patient ID.
     * @dev This function is public, allowing anyone to view the immutable data.
     * @param _patientId The unique ID of the patient.
     * @return The immutable health report data string.
     */
    function getReport(uint _patientId) public view returns (string memory) {
        return patientReports[_patientId];
    }

    /**
     * @notice Returns the address of the contract owner.
     */
    function getOwner() public view returns (address) {
        return owner;
    }
}
