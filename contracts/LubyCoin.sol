// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzepelling/contracts/token/ERC20/ERC20.sol";
import "@openzepelling/contracts/security/Pausable.sol";
import "@openzepelling/contracts/access/Ownable.sol";

contract LubyCoin is Ownable, Pausable, ERC20 {
    uint256 _tax = 10;
    mapping(address => bool) private _vips;
    mapping(address => uint256) private _lastTransaction;

    constructor(uint256 _initialSupply) ERC20("LubyCoin", "LBC") {
        _mint(msg.sender, _initialSupply);
    }

    modifier canDonate(address donor) {
        uint lastDonorTransaction = _lastTransaction[donor];
        require((lastDonorTransaction + 1 months) <= now, "LubyCoin: You need to wait a month before donating again");
        require(msg.value <= 1 ether, "LubyCoin: You can donate a maximum of 1 ether");
        _;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }


    function makeVip(address _newVip) public onlyOwner {
        _vips[_newVip] = true;
    }

    function setTax(uint256 _newTax) public onlyOwner {
        require(_newTax >= 0, "LubyCoin: Tax can't be negative");
        _tax = _newTax;
    }
}
