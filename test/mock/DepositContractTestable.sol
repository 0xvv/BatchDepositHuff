// SPDX-License-Identifier: BUSL-1.1
// SPDX-FileCopyrightText: 2023 Kiln <contact@kiln.fi>
//
// ██╗  ██╗██╗██╗     ███╗   ██╗
// ██║ ██╔╝██║██║     ████╗  ██║
// █████╔╝ ██║██║     ██╔██╗ ██║
// ██╔═██╗ ██║██║     ██║╚██╗██║
// ██║  ██╗██║███████╗██║ ╚████║
// ╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═══╝
//
pragma solidity >=0.8.17;

import "../../src/interface/IDeposit.sol";

contract DepositContractTestable is IDeposit {

    uint256 public deposit_count;

    bytes32[] public depositDataRoots;
    bytes[] public depositPubkeys;
    bytes[] public depositWithdrawalCredentials;
    bytes[] public depositSignatures;

    event DepositEvent(
        bytes pubkey,
        bytes withdrawal_credentials,
        bytes signature,
        bytes32 deposit_data_root
    );

    function deposit(
        bytes calldata pubkey,
        bytes calldata withdrawal_credentials,
        bytes calldata signature,
        bytes32 deposit_data_root
    ) external payable override {
        deposit_count += 1;
        emit DepositEvent(pubkey, withdrawal_credentials, signature, deposit_data_root);
        /*
        depositDataRoots.push(deposit_data_root);
        depositPubkeys.push(pubkey);
        depositWithdrawalCredentials.push(withdrawal_credentials);
        depositSignatures.push(signature);
        */
    }
}
