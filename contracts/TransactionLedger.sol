// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract TransactionLedger {
    mapping(address => mapping(address => uint256)) private _transactions;

    constructor() public {}

    function recordTransaction(
        address _source,
        address _target,
        uint256 _amount
    ) internal {
        _transactions[_source][_target] = _amount;
    }

    function recoverTransactions(address _source)
        internal
        returns (mapping(address => uint256))
    {
        return _transactions[_source];
    }
}
