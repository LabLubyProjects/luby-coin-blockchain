// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@quant-finance/solidity-datetime/contracts/DateTime.sol";
import "./TransactionLedger.sol";

contract LubyCoin is ERC20, Ownable, Pausable, TransactionLedger {
    using DateTime for uint256;

    uint256 _tax = 10000;
    mapping(address => bool) private _vips;
    mapping(address => uint256) private _lastTransaction;

    constructor(uint256 _initialSupply) ERC20("LubyCoin", "LBC") {
        _mint(_msgSender(), _initialSupply * 10**decimals());
    }

    function decimals() public pure override returns (uint8) {
        return 3;
    }

    modifier canDonate(address donor, uint256 amount) {
        uint256 lastDonorTransaction = _lastTransaction[donor];
        require(
            lastDonorTransaction.addMonths(1) <= block.timestamp,
            "LubyCoin: You need to wait a month before donating again"
        );
        require(
            amount <= 1000,
            "LubyCoin: You can donate a maximum of 1 LubyCoin"
        );
        _;
    }

    function _calculateFee(uint256 amount) internal view returns (uint256) {
        uint256 fee = (amount * _tax) / 100000;
        return fee;
    }

    function _chargeFeeAndReturnNewAmount(uint256 amount)
        internal
        returns (uint256)
    {
        uint256 fee = _calculateFee(amount);
        transfer(address(this), fee);
        amount = amount - fee;
        return amount;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function makeVip(address _newVip) public whenNotPaused onlyOwner {
        _vips[_newVip] = true;
    }

    function revokeVip(address _exVip) public whenNotPaused onlyOwner {
        _vips[_exVip] = false;
    }

    function setTax(uint256 _newTax) public whenNotPaused onlyOwner {
        require(_newTax >= 0, "LubyCoin: Tax can't be negative");
        _tax = _newTax;
    }

    function transferTo(address to, uint256 amount)
        public
        whenNotPaused
        returns (bool)
    {
        if (!_vips[_msgSender()]) {
            amount = _chargeFeeAndReturnNewAmount(amount);
        }

        return transfer(to, amount);
    }

    function donate(address to, uint256 amount)
        public
        payable
        whenNotPaused
        canDonate(_msgSender(), amount)
        returns (bool)
    {
        if (!_vips[_msgSender()]) {
            amount = _chargeFeeAndReturnNewAmount(amount);
        }
        _lastTransaction[_msgSender()] = block.timestamp;
        return transfer(to, amount);
    }

    function withdrawAll() public whenNotPaused onlyOwner {
        address selfAddress = address(this);
        _transfer(selfAddress, _msgSender(), uint256(balanceOf(selfAddress)));
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        recordTransaction(from, to, amount);
    }
}
