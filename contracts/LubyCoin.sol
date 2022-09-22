// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzepelling/contracts/token/ERC20/ERC20.sol";
import "@openzepelling/contracts/security/Pausable.sol";
import "@openzepelling/contracts/access/Ownable.sol";

contract LubyCoin is Ownable, Pausable, ERC20 {
    uint256 _tax = 10000;
    mapping(address => bool) private _vips;
    mapping(address => uint256) private _lastTransaction;

    constructor(uint256 _initialSupply) ERC20("LubyCoin", "LBC") {
        _mint(_msgSender(), _initialSupply);
    }

    function decimals() public view override returns (uint8) {
        return 3;
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

    function _calculateFee(uint256 amount) internal returns (uint256) {
        uint256 fee = amount * _tax / 100000;
        return fee;
    }

    function _chargeFeeAndReturnNewAmount(uint256 amount) internal returns (uint256) {
        uint256 fee = _calculateFee(amount);
        transfer(address(this), fee);
        amount = amount - fee;
        return amount
    }

    function transferTo(address to, uint256 amount) public returns (bool) {
        if(!_vips[_msgSender()]) {
           amount = _chargeFeeAndReturnNewAmount(amount);
        }

        return transfer(to, amount);
    }

    function donate(address to, uint256 amount) public canDonate returns (bool) {
        if(!_vips[_msgSender()]) {
           amount = _chargeFeeAndReturnNewAmount(amount);
        }

        return transfer(to, amount);
    }

    function withdrawAll() internal onlyOwner {
        address self = address(this); 
        transfer(self, _balance(self));
    }
}
