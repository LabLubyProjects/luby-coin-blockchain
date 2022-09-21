// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzepelling/contracts/token/ERC20/ERC20.sol";
import "@openzepelling/contracts/security/Pausable.sol";
import "@openzepelling/contracts/access/Ownable.sol";

contract LubyCoin is Ownable, Pausable, ERC20 {}
