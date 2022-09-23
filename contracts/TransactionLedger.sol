// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract TransactionLedger {
    mapping(address => mapping(address => mapping(uint256 => uint256)))
        private _transactions;

    function recordTransaction(
        address _source,
        address _target,
        uint256 _amount
    ) internal {
        _transactions[_source][_target][block.timestamp] = _amount;
    }

    function recoverTransactions(
        address _source,
        address _target,
        uint256 _moment
    ) public view returns (uint256) {
        return _transactions[_source][_target][_moment];
    }
}
