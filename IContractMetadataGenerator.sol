// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IContractMetadataGenerator {
    function generateContractMetadata() external view returns (string memory);
}
