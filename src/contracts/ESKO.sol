// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title ESKO contract
 * NOTE: Contract inherit from openzeppelin ERC20
 */
contract ESKO is ERC20 {
    /**
     * @dev Each token has 18 decimals
     * Mint initial 1000000 amount of tokens for the owner
     */
    constructor() ERC20("ESKO", "ESKO") {
        _mint(msg.sender, 1000000 * 10**18);
    }
}
