# 🏥 Medichain – Immutable Health Report Storage on Blockchain

<img width="1920" height="1080" alt="Screenshot (1)" src="https://github.com/user-attachments/assets/8e19820f-4712-47fe-bed2-5b8a77755e4b" />


## 📘 Project Description

**Medichain** is a blockchain-based decentralized application (dApp) that provides a **secure, transparent, and immutable way to store health reports**.  
Built on the **Celo** blockchain, this smart contract ensures that once a medical report is added, it **cannot be modified or deleted**, preserving the integrity of health data forever.

This project is perfect for learning how to use Solidity for real-world applications in healthcare data security.

---

## 💡 What It Does

Medichain allows:
- The **contract owner (deployer)** to add health reports linked to unique patient IDs.  
- **Anyone** to view these reports on-chain at any time.  

By storing health report data (e.g., JSON strings, hashes, or summary texts) immutably, it provides a **trustless record system**—ideal for patient verification, medical research, and record transparency.

---

## ✨ Features

✅ **Immutable Storage:** Once a report is uploaded, it cannot be overwritten or removed.  
✅ **Ownership Control:** Only the deployer (owner) can add new reports, preventing unauthorized data injection.  
✅ **Public Transparency:** Anyone can retrieve stored reports securely and instantly.  
✅ **Event Logging:** Emits events (`ReportAdded`) for easy tracking and integration with off-chain systems.  
✅ **Celo Blockchain Powered:** Uses Celo’s eco-friendly blockchain for low-cost and accessible deployment.

---

## 🌐 Deployed Smart Contract

You can explore the live deployed contract here:  
🔗 **[View on Celo Blockscout](https://celo-sepolia.blockscout.com/address/0xd792a6D54CdF594282900C03FdC9BF008Eceec8c)**

---

## 🧠 Smart Contract Code

```solidity
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


