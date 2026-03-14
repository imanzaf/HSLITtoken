// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Heathrow Slot Lease Income Token (HSLIT)
/// @notice ERC-20 token representing fractional claims on slot lease income
/// routed through a Special Purpose Vehicle under a Revenue Participation
/// Agreement with Meridian Airways. Deployed on Sepolia testnet.

contract HSLIT is ERC20, Ownable {

    string public description =
        "HSLIT: Heathrow Slot Lease Income Token. "
        "Represents fractional claims on slot lease income routed through "
        "an SPV under a Revenue Participation Agreement with Meridian Airways.";

    address public servicer;

    event ServicerUpdated(address indexed oldServicer, address indexed newServicer);
    event IncomeDistributed(uint256 amount);

    constructor(address initialServicer)
        ERC20("Heathrow Slot Lease Income Token", "HSLIT")
        Ownable(msg.sender)
    {
        servicer = initialServicer;
        _mint(msg.sender, 10_000_000 * 10 ** decimals());
    }

    modifier onlyServicer() {
        require(msg.sender == servicer, "Caller is not the servicer");
        _;
    }

    /// @notice Update the servicer address (governance function)
    function updateServicer(address newServicer) external onlyOwner {
        emit ServicerUpdated(servicer, newServicer);
        servicer = newServicer;
    }

    /// @notice Called by servicer to log a verified income distribution event
    function distribute(uint256 amount) external onlyServicer {
        emit IncomeDistributed(amount);
    }

    /// @notice Burn tokens at RPA expiry for redemption
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}