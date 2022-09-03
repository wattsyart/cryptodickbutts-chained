// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.13;

import "@divergencetech/ethier/contracts/random/PRNG.sol";

import "./lib/interfaces/IRandom.sol";
import "./lib/interfaces/IBuilder.sol";
import "./lib/interfaces/IMetadata.sol";
import "./lib/interfaces/IStrings.sol";
import "./lib/interfaces/ITokenURIBuilder.sol";

import "./lib/graphics/ISVGWrapper.sol";

contract CryptoDickbuttsRandom is IRandom {
    function randomImageURI(
        uint64 seed,
        IBuilder builder,
        IPixelRenderer renderer,
        IAnimationEncoder encoder
    )
        external
        view
        override
        returns (string memory imageUri, uint8[] memory metadata)
    {
        metadata = _randomMeta(seed);
        imageUri = builder.getImage(renderer, encoder, metadata, 0);
        return (imageUri, metadata);
    }

    function _randomMeta(uint64 seed)
        private
        pure
        returns (uint8[] memory meta)
    {
        meta = new uint8[](12);
        PRNG.Source src = PRNG.newSource(keccak256(abi.encodePacked(seed)));

        // Background
        meta[0] = uint8(PRNG.readLessThan(src, 8, 8));

        // Skin
        meta[1] = 181 + uint8(PRNG.readLessThan(src, 11, 8));

        // Body
        if (PRNG.readBool(src)) {
            meta[2] = 8 + uint8(PRNG.readLessThan(src, 18, 8));
        } else {
            meta[2] = 194;
        }

        // Hat
        if (PRNG.readBool(src)) {
            meta[3] = 96 + uint8(PRNG.readLessThan(src, 52, 8));
        } else {
            meta[3] = 195;
        }

        // Eyes
        if (PRNG.readBool(src)) {
            meta[4] = 48 + uint8(PRNG.readLessThan(src, 25, 8));
        } else {
            meta[3] = 196;
        }

        // Mouth
        if (PRNG.readBool(src)) {
            meta[5] = 162 + uint8(PRNG.readLessThan(src, 4, 8));
        } else {
            meta[5] = 197;
        }

        // Nose
        if (PRNG.readBool(src)) {
            meta[6] = 166 + uint8(PRNG.readLessThan(src, 3, 8));
        } else {
            meta[6] = 198;
        }

        // Hand
        if (PRNG.readBool(src)) {
            meta[7] = 73 + uint8(PRNG.readLessThan(src, 23, 8));
        } else {
            meta[7] = 199;
        }

        // Shoes
        if (PRNG.readBool(src)) {
            meta[8] = 169 + uint8(PRNG.readLessThan(src, 12, 8));
        } else {
            meta[8] = 200;
        }

        // Butt
        if (PRNG.readBool(src)) {
            meta[9] = 26 + uint8(PRNG.readLessThan(src, 3, 8));
        } else {
            meta[9] = 201;
        }

        // Dick
        if (PRNG.readBool(src)) {
            meta[10] = 29 + uint8(PRNG.readLessThan(src, 19, 8));
        } else {
            meta[10] = 202;
        }

        // Special
        if (PRNG.readBool(src)) {
            meta[11] = 192 + uint8(PRNG.readLessThan(src, 2, 8));
        } else {
            meta[11] = 203;
        }
    }
}
