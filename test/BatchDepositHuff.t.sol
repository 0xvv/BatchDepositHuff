pragma solidity 0.8.20;

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "./mock//DepositContractTestable.sol";
import "./utils/BytesGenerator.sol";
import "../src/lib/LibBytes.sol";

interface IBatchDepositBis {
    function deposit(bytes calldata data) external payable;
}

contract BatchDepositHuffTest is Test, BytesGenerator {
    IBatchDepositBis huffbdo;

    address constant officialDepositContract = 0x00000000219ab540356cBB839Cbe05303d7705Fa;

    DepositContractTestable huffDepMock = DepositContractTestable(officialDepositContract);
    DepositContractTestable implem = new DepositContractTestable();

    function deployHuff() public {
        vm.etch(officialDepositContract, address(implem).code);
        address addr = HuffDeployer.deploy("BatchDepositCompact");
        console.log("Huff deployed", addr, addr.code.length);
        assertTrue(addr != address(0));
        huffbdo = IBatchDepositBis(addr);
    }

    function setUp() public {
        deployHuff();
    }

    function checkDepositCount(uint256 count) internal {
        assertEq(huffDepMock.deposit_count(), count);
    }

    function test_d() public {
        console.log("d", address(this).balance);
    }

    function test_batchDeposit_match() public {
        //setSalt(bytes32(abi.encodePacked()));
        //c = bound(c, 1, 200);
        uint256 c = 1;
        uint256 COUNT = uint256(c);

        console.log("COUNT", COUNT);

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
            args = bytes.concat(args, pubkeys[i]);
            args = bytes.concat(args, withdrawal_credentials[i]);
            args = bytes.concat(args, signatures[i]);
            args = bytes.concat(args, deposit_data_roots[i]);
        }

        vm.deal(address(this), 32 ether * COUNT);

        // HUFF
        huffbdo.deposit{value: 32 ether * COUNT}(args);
/*
        for (uint256 i; i < COUNT; i++) {
            assertEq(huffDepMock.depositDataRoots(i), deposit_data_roots[i]);
            assertEq(huffDepMock.depositPubkeys(i), pubkeysList[i]);
            assertEq(huffDepMock.depositWithdrawalCredentials(i), withdrawalCredentialsList[i]);
            assertEq(huffDepMock.depositSignatures(i), signaturesList[i]);
        }
        checkDepositCount(COUNT);*/
    }
}
