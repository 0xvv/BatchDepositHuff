// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "foundry-huff/HuffDeployer.sol";

interface IBatchDeposit {
    function d(
        bytes calldata pubkeys,
        bytes calldata withdrawal_credentialss,
        bytes calldata signatures,
        bytes32[] calldata deposit_data_roots
    ) external payable;

    function d(bytes calldata args) external payable;
}

contract BenchmarkCompact is Script {
    address public huffCompact;
    uint256 public runCount = 13;

    function setUp() public {}

    function run() public {
        uint256[] memory validatorsCount = getValidatorsCount();

        // Deploy BatchDepositCompact
        huffCompact = HuffDeployer.broadcast("BatchDepositCompact");
        console.log("BatchDepositCompact: ", huffCompact);

        {
            for (uint256 i = 0; i < runCount; i++) {
                uint256 count = validatorsCount[i];
                bytes memory args = makeArg(count);

                console.log("compact huff");
                vm.startBroadcast();
                IBatchDeposit(huffCompact).d{value: 32 ether * count}(args);
                vm.stopBroadcast();
            }
        }

        console.log("Done!");
    }

    function getValidatorsCount() public view returns (uint256[] memory) {
        uint256[] memory validatorsCount = new uint256[](runCount);
        validatorsCount[0] = 1;
        validatorsCount[1] = 2;
        validatorsCount[2] = 3;
        validatorsCount[3] = 4;
        validatorsCount[4] = 5;
        validatorsCount[5] = 10;
        validatorsCount[6] = 20;
        validatorsCount[7] = 30;
        validatorsCount[8] = 40;
        validatorsCount[9] = 50;
        validatorsCount[10] = 75;
        validatorsCount[11] = 100;
        validatorsCount[12] = 200;
        return validatorsCount;
    }

    function makeArg(uint256 count) public pure returns (bytes memory args) {
        args = new bytes(0);
        for (uint256 i = 0; i < count; i++) {
            args = bytes.concat(args, genPubkey());
            args = bytes.concat(args, genWC());
            args = bytes.concat(args, genSig());
            args = bytes.concat(args, genBytes32());
        }
    }
}

function genPubkey() pure returns (bytes memory) {
    return hex"97eda78a0c1c3746d429451f194cce479b9aac7770eae790c638014087aceebcb4c68236e99e65f645fc1a436f059ab9";
}

function genWC() pure returns (bytes memory) {
    return hex"01000000000000000000000034e9cb03516a70466d5c6d25c0f37cf622c43242";
}

function genSig() pure returns (bytes memory) {
    return
    hex"b81b4423943820252a4a266a88eec5a87753191bd1838ffd3297dc44981368b186eae4f1fe0174b337c94064cf78f18f087785f60aa97db10e9e9d3826d1fc48baae3f9f94c7eb293354f56921a675db19f683ee12ec5508cdfb42805244d06f";
}

function genBytes32() pure returns (bytes32) {
    return bytes32(hex"f1b0122e593763eb4fbe7b345f4fa9ec77f3096cbaec29bcec94b83b42d13579");
}
