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

abstract contract BytesGenerator {
    bytes32 salt = bytes32(0);

    function BytesGenerator_slice(bytes memory _bytes, uint256 _start, uint256 _length)
        internal
        pure
        returns (bytes memory)
    {
        require(_length + 31 >= _length, "slice_overflow");
        require(_bytes.length >= _start + _length, "slice_outOfBounds");

        bytes memory tempBytes;

        assembly {
            switch iszero(_length)
            case 0 {
                tempBytes := mload(0x40)
                let lengthmod := and(_length, 31)
                let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
                let end := add(mc, _length)

                for { let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start) } lt(mc, end) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } { mstore(mc, mload(cc)) }

                mstore(tempBytes, _length)
                mstore(0x40, and(add(mc, 31), not(31)))
            }
            default {
                tempBytes := mload(0x40)
                mstore(tempBytes, 0)
                mstore(0x40, add(tempBytes, 0x20))
            }
        }

        return tempBytes;
    }

    function setSalt(bytes32 _salt) internal {
        salt = _salt;
    }

    function genBytes(uint256 len) internal returns (bytes memory) {
        bytes memory res = "";
        while (res.length < len) {
            salt = keccak256(abi.encodePacked(salt));
            if (len - res.length >= 32) {
                res = bytes.concat(res, abi.encode(salt));
            } else {
                res = bytes.concat(res, BytesGenerator_slice(abi.encode(salt), 0, len - res.length));
            }
        }
        return res;
    }
}
