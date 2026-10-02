// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

/// @notice Mock DIP distribution contract for testing
contract MockDipDistribution {
    /// @notice Map of schemes and their distributions
    mapping(address => uint256) public schemeDistributions;

    /// @notice Map of scheme and recipient to their distribution amount
    mapping(address => mapping(address => uint256)) public recipientDistributions;

    /// @notice Event emitted when distribution is set for a scheme
    event SchemeDistributionSet(address indexed scheme, uint256 amount);

    /// @notice Event emitted when distribution is set for a recipient
    event RecipientDistributionSet(address indexed scheme, address indexed recipient, uint256 amount);

    /// @notice Set the distribution amount for a scheme
    function setSchemeDistribution(address scheme, uint256 amount) external {
        schemeDistributions[scheme] = amount;
        emit SchemeDistributionSet(scheme, amount);
    }

    /// @notice Set the distribution amount for a recipient in a scheme
    function setRecipientDistribution(address scheme, address recipient, uint256 amount) external {
        recipientDistributions[scheme][recipient] = amount;
        emit RecipientDistributionSet(scheme, recipient, amount);
    }

    /// @notice Get the distribution amount for a scheme
    function getSchemeDistribution(address scheme) external view returns (uint256) {
        return schemeDistributions[scheme];
    }

    /// @notice Get the distribution amount for a recipient in a scheme
    function getRecipientDistribution(address scheme, address recipient) external view returns (uint256) {
        return recipientDistributions[scheme][recipient];
    }

    /// @notice Distribute tokens to recipients
    function distribute(IERC20 token, address[] calldata recipients, uint256[] calldata amounts) external {
        require(recipients.length == amounts.length, "MockDipDistribution: length mismatch");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            token.transfer(recipients[i], amounts[i]);
            emit RecipientDistributionSet(msg.sender, recipients[i], amounts[i]);
        }
    }

    /// @notice Claim tokens for a recipient
    function claim(address scheme, address recipient, uint256 amount) external {
        recipientDistributions[scheme][recipient] -= amount;
        emit RecipientDistributionSet(scheme, recipient, amount);
    }
}
