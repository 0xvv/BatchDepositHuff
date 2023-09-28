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
    uint256 constant DEPOSIT_CONTRACT_TREE_DEPTH = 32;
    // NOTE: this also ensures `deposit_count` will fit into 64-bits
    uint256 constant MAX_DEPOSIT_COUNT = 2 ** DEPOSIT_CONTRACT_TREE_DEPTH - 1;

    bytes32[DEPOSIT_CONTRACT_TREE_DEPTH] branch;
    uint256 public deposit_count;

    bytes32[DEPOSIT_CONTRACT_TREE_DEPTH] zero_hashes;

    bytes32[] public depositDataRoots;
    bytes[] public depositPubkeys;
    bytes[] public depositWithdrawalCredentials;
    bytes[] public depositSignatures;

    constructor() {
        // Compute hashes in empty sparse Merkle tree
        for (uint256 height = 0; height < DEPOSIT_CONTRACT_TREE_DEPTH - 1; height++) {
            zero_hashes[height + 1] = sha256(abi.encodePacked(zero_hashes[height], zero_hashes[height]));
        }
    }

    function get_deposit_root() external view returns (bytes32) {
        bytes32 node;
        uint256 size = deposit_count;
        for (uint256 height = 0; height < DEPOSIT_CONTRACT_TREE_DEPTH; height++) {
            if ((size & 1) == 1) {
                node = sha256(abi.encodePacked(branch[height], node));
            } else {
                node = sha256(abi.encodePacked(node, zero_hashes[height]));
            }
            size /= 2;
        }
        return sha256(abi.encodePacked(node, to_little_endian_64(uint64(deposit_count)), bytes24(0)));
    }

    function get_deposit_count() external view returns (bytes memory) {
        return to_little_endian_64(uint64(deposit_count));
    }

    bool dataRootCheck = false;

    function debug_enableDataRootCheck() external {
        dataRootCheck = true;
    }

    function deposit(
        bytes calldata pubkey,
        bytes calldata withdrawal_credentials,
        bytes calldata signature,
        bytes32 deposit_data_root
    ) external payable override {
        depositDataRoots.push(deposit_data_root);
        depositPubkeys.push(pubkey);
        depositWithdrawalCredentials.push(withdrawal_credentials);
        depositSignatures.push(signature);

        // Add deposit data root to Merkle tree (update a single `branch` node)
        deposit_count += 1;
    }

    function to_little_endian_64(uint64 value) internal pure returns (bytes memory ret) {
        ret = new bytes(8);
        bytes8 bytesValue = bytes8(value);
        // Byteswapping during copying to bytes.
        ret[0] = bytesValue[7];
        ret[1] = bytesValue[6];
        ret[2] = bytesValue[5];
        ret[3] = bytesValue[4];
        ret[4] = bytesValue[3];
        ret[5] = bytesValue[2];
        ret[6] = bytesValue[1];
        ret[7] = bytesValue[0];
    }
}
