// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.13;

import "./IMetadata.sol";
import "./IStrings.sol";

interface ITokenURIBuilder {
    function build(
        IMetadata metadata,
        IStrings strings,
        uint256 seedOrTokenId,
        string memory imageUri,
        string memory imageDataUri,
        bytes memory description,
        bytes memory externalUrl,
        bytes memory prefix,
        uint8[] memory meta
    ) external view returns (string memory);
}
