// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzepelling/contracts/token/ERC20/ERC20.sol";
import "@openzepelling/contracts/security/Pausable.sol";
import "@openzepelling/contracts/access/Ownable.sol";

contract LubyCoin is Ownable, Pausable, ERC20 {
    uint _tax = 10;
    mapping(address => bool) private _vips;
    mapping(address => uint) private _lastTransaction;

    constructor(uint _initialSupply) ERC20("LubyCoin", "LBC") {
        _mint(msg.sender, _initialSupply);
    }
}
