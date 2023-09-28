// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @notice  Interface of the official Deposit contract from the ETH
///          Foundation.
interface IDeposit {
    event DepositEvent(bytes pubkey, bytes withdrawal_credentials, bytes amount, bytes signature, bytes index);

    /// @notice Submit a Phase 0 DepositData object.
    ///
    /// @param pubkey - A BLS12-381 public key.
    /// @param withdrawal_credentials - Commitment to a public key for withdrawals.
    /// @param signature - A BLS12-381 signature.
    /// @param deposit_data_root - The SHA-256 hash of the SSZ-encoded DepositData object.
    ///                            Used as a protection against malformed input.
    function deposit(
        bytes calldata pubkey,
        bytes calldata withdrawal_credentials,
        bytes calldata signature,
        bytes32 deposit_data_root
    ) external payable;

    /// @notice Return the deposit count.
    function deposit_count() external view returns (uint256);
}
