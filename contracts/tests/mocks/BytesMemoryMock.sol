// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../../libraries/BytesMemory.sol";

contract BytesMemoryMock {
    using BytesMemory for BytesMemory.Slice;

    error GasCostDiffers(uint256 expected, uint256 actual);

    function wrap(bytes memory data) public pure returns (BytesMemory.Slice memory) {
        return BytesMemory.wrap(data);
    }

    function wrapWithNonDefaultPointer(bytes calldata data, uint256 n) public pure returns (BytesMemory.Slice memory) {
        new address[](n);
        return BytesMemory.wrap(data);
    }

    function slice(BytesMemory.Slice memory data, uint256 offset, uint256 size) public pure returns (BytesMemory.Slice memory) {
        return data.slice(offset, size);
    }

    function wrapAndUnwrap(bytes memory data) external view returns (bytes memory ret) {
        return wrap(data).unwrap();
    }

    function wrapAndUnwrapWithGasCost(bytes memory data, uint256 expectedGasCost) external view returns (bytes memory ret) {
        BytesMemory.Slice memory slice_ = wrap(data);
        uint256 gas = gasleft();
        ret = slice_.unwrap();
        unchecked {
            gas -= gasleft();
        }
        if (expectedGasCost > 0 && gas != expectedGasCost) {
            revert GasCostDiffers(expectedGasCost, gas);
        }
    }

    function wrapWithNonDefaultPointerAndUnwrap(bytes calldata data, uint256 n) external view returns (bytes memory ret) {
        return wrapWithNonDefaultPointer(data, n).unwrap();
    }

    function wrapWithSliceAndUnwrap(bytes calldata data, uint256 offset, uint256 size) external view returns (bytes memory ret) {
        return wrap(data).slice(offset, size).unwrap();
    }
}
