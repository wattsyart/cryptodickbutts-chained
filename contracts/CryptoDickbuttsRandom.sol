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
        imageUri = builder.getImage(renderer, encoder, metadata);
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
        meta[0] = uint8(PRNG.readLessThan(src, 9, 8));

        // Skin
        meta[1] = 189 + uint8(PRNG.readLessThan(src, 11, 8));

        // Body
        if (PRNG.readBool(src)) {
            meta[2] = 9 + uint8(PRNG.readLessThan(src, 19, 8));
        } else {
            meta[2] = 204;
        }

        // Hat
        if (PRNG.readBool(src)) {
            meta[3] = 101 + uint8(PRNG.readLessThan(src, 53, 8));
        } else {
            meta[3] = 205;
        }

        // Eyes
        if (PRNG.readBool(src)) {
            meta[4] = 51 + uint8(PRNG.readLessThan(src, 26, 8));
        } else {
            meta[3] = 206;
        }

        // Mouth
        if (PRNG.readBool(src)) {
            meta[5] = 169 + uint8(PRNG.readLessThan(src, 5, 8));
        } else {
            meta[5] = 207;
        }

        // Nose
        if (PRNG.readBool(src)) {
            meta[6] = 173 + uint8(PRNG.readLessThan(src, 4, 8));
        } else {
            meta[6] = 208;
        }

        // Hand
        if (PRNG.readBool(src)) {
            meta[7] = 77 + uint8(PRNG.readLessThan(src, 24, 8));
        } else {
            meta[7] = 209;
        }

        // Shoes
        if (PRNG.readBool(src)) {
            meta[8] = 177 + uint8(PRNG.readLessThan(src, 13, 8));
        } else {
            meta[8] = 210;
        }

        // Butt
        if (PRNG.readBool(src)) {
            meta[9] = 28 + uint8(PRNG.readLessThan(src, 4, 8));
        } else {
            meta[9] = 211;
        }

        // Dick
        if (PRNG.readBool(src)) {
            meta[10] = 32 + uint8(PRNG.readLessThan(src, 20, 8));
        } else {
            meta[10] = 212;
        }

        // Special
        if (PRNG.readBool(src)) {
            meta[11] = 200 + uint8(PRNG.readLessThan(src, 4, 8));
        } else {
            meta[11] = 213;
        }
    }
}
