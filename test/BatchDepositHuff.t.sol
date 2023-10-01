// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "./mock/DepositContractTestable.sol";
import "./utils/BytesGenerator.sol";
import "../src/lib/LibBytes.sol";

interface IBatchDepositCompact {
    function deposit(bytes calldata data) external payable;
}

interface IBatchDepositClassic {
    function deposit(
        bytes calldata pubkeys,
        bytes calldata withdrawal_credentials,
        bytes calldata signatures,
        bytes32[] calldata deposit_data_roots
    ) external payable;
}

contract BatchDepositHuffTest is Test, BytesGenerator {
    IBatchDepositCompact huffCompact;
    IBatchDepositClassic huffClassic;

    address constant officialDepositContract = 0x00000000219ab540356cBB839Cbe05303d7705Fa;

    DepositContractTestable huffDepMock;

    function deployHuffCompact() public {
        address addr = HuffDeployer.deploy("BatchDepositCompact");
        console.log("Huff deployed", addr, addr.code.length);
        assertTrue(addr != address(0));
        huffCompact = IBatchDepositCompact(addr);
    }

    function deployHuffClassic() public {
        address addr = HuffDeployer.deploy("BatchDeposit");
        console.log("Huff classic deployed", addr, addr.code.length);
        assertTrue(addr != address(0));
        huffClassic = IBatchDepositClassic(addr);
    }

    function setUp() public {
        huffDepMock = new DepositContractTestable();
        vm.etch(officialDepositContract, address(huffDepMock).code);

        deployHuffCompact();
        deployHuffClassic();
    }

    function checkDepositCount(uint256 count) internal {
        assertEq(DepositContractTestable(officialDepositContract).deposit_count(), count);
    }

    function test_batchDepositCompact_match(uint256 c) public {
        setSalt(bytes32(abi.encodePacked(c)));
        c = bound(c, 1, 200);
        uint256 COUNT = uint256(c);

        bytes memory pubkeys = genBytes(48 * COUNT);
        bytes memory withdrawal_credentials = genBytes(32 * COUNT);
        bytes memory signatures = genBytes(96 * COUNT);
        bytes32[] memory deposit_data_roots = new bytes32[](COUNT);
        bytes[] memory pubkeysList = new bytes[](COUNT);
        bytes[] memory withdrawalCredentialsList = new bytes[](COUNT);
        bytes[] memory signaturesList = new bytes[](COUNT);
        for (uint256 i = 0; i < COUNT; i++) {
            pubkeysList[i] = LibBytes.slice(pubkeys, i * 48, 48);
            withdrawalCredentialsList[i] = LibBytes.slice(withdrawal_credentials, i * 32, 32);
            signaturesList[i] = LibBytes.slice(signatures, i * 96, 96);
            deposit_data_roots[i] = bytes32(genBytes(32));
        }
        bytes memory args = new bytes(0);
        for (uint256 i = 0; i < COUNT; i++) {
            args = bytes.concat(args, pubkeysList[i]);
            args = bytes.concat(args, withdrawalCredentialsList[i]);
            args = bytes.concat(args, signaturesList[i]);
            args = bytes.concat(args, deposit_data_roots[i]);
        }

        vm.deal(address(this), 32 ether * COUNT);

        for (uint256 i = 0; i < COUNT; i++) {
            vm.expectEmit(true, true, true, true);
            emit DepositEvent(pubkeysList[i], withdrawalCredentialsList[i], signaturesList[i], deposit_data_roots[i]);
        }

        huffCompact.deposit{value: 32 ether * COUNT}(args);

        checkDepositCount(COUNT);
    }

    function test_batchDepositClasssic_match(uint256 c) public {
        setSalt(bytes32(abi.encodePacked(c)));
        c = bound(c, 1, 200);
        uint256 COUNT = c;

        bytes memory pubkeys = genBytes(48 * COUNT);
        bytes memory withdrawal_credentials = genBytes(32 * COUNT);
        bytes memory signatures = genBytes(96 * COUNT);
        bytes32[] memory deposit_data_roots = new bytes32[](COUNT);
        bytes[] memory pubkeysList = new bytes[](COUNT);
        bytes[] memory withdrawalCredentialsList = new bytes[](COUNT);
        bytes[] memory signaturesList = new bytes[](COUNT);
        for (uint256 i = 0; i < COUNT; i++) {
            pubkeysList[i] = LibBytes.slice(pubkeys, i * 48, 48);
            withdrawalCredentialsList[i] = LibBytes.slice(withdrawal_credentials, i * 32, 32);
            signaturesList[i] = LibBytes.slice(signatures, i * 96, 96);
            deposit_data_roots[i] = bytes32(genBytes(32));
        }

        vm.deal(address(this), 32 ether * COUNT);

        for (uint256 i = 0; i < COUNT; i++) {
            vm.expectEmit(true, true, true, true);
            emit DepositEvent(pubkeysList[i], withdrawalCredentialsList[i], signaturesList[i], deposit_data_roots[i]);
        }

        huffClassic.deposit{value: 32 ether * COUNT}(pubkeys, withdrawal_credentials, signatures, deposit_data_roots);

        checkDepositCount(COUNT);
    }

    event DepositEvent(bytes pubkey, bytes withdrawal_credentials, bytes signature, bytes32 deposit_data_root);
}
