// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

import "./lib/interfaces/IBuilder.sol";
import "./lib/interfaces/IMetadata.sol";
import "./lib/interfaces/IStrings.sol";
import "./lib/interfaces/IRandom.sol";
import "./lib/interfaces/ITokenURIBuilder.sol";

import "./lib/graphics/IAnimationEncoder.sol";
import "./lib/graphics/IPixelRenderer.sol";

contract CryptoDickbuttsChained is Ownable {
    bytes public constant DESCRIPTION =
        "Once a utopia, Gooch Island has fallen and CryptoDickbutts have been evacuated. Series 3 features 5200 all new CryptoDickbutts, each with a set of randomly generated traits.";
    bytes public constant EXTERNAL_URL = "https://cryptodickbutts.com/";
    bytes public constant PREFIX = "CryptoDickbutt";

    error URIQueryForNonExistentToken(uint256 tokenId);

    using ERC165Checker for address;

    /** @notice Contract responsible for looking up metadata. */
    IMetadata public metadata;

    /**
    @notice Sets the address of the metadata provider contract.
     */
    function setMetadata(address _metadata) external onlyOwner {
        metadata = IMetadata(_metadata);
    }

    /** @notice Contract responsible for building images. */
    IBuilder public builder;

    /**
    @notice Sets the address of the builder contract.
     */
    function setBuilder(address _builder) external onlyOwner {
        builder = IBuilder(_builder);
    }

    /** @notice Contract responsible for encoding images */
    IAnimationEncoder public encoder;

    /**
    @notice Sets the address of the encoder contract.
     */
    function setEncoder(address _encoder) external onlyOwner {
        encoder = IAnimationEncoder(_encoder);
    }

    /** @notice Contract responsible for rastering images */
    IPixelRenderer public renderer;

    /**
    @notice Sets the address of the renderer contract.
     */
    function setRenderer(address _renderer) external onlyOwner {
        renderer = IPixelRenderer(_renderer);
    }

    /** @notice Contract responsible for looking up strings. */
    IStrings public strings;

    /**
    @notice Sets the address of the string provider contract.
     */
    function setStrings(address _strings) external onlyOwner {
        strings = IStrings(_strings);
    }

    /** @notice Contract responsible for wrapping images in SVG for display. */
    ISVGWrapper public svgWrapper;

    /**
    @notice Sets the address of the SVG wrapper contract.
     */
    function setSVGWrapper(address _svgWrapper) external onlyOwner {
        svgWrapper = ISVGWrapper(_svgWrapper);
    }

    /** @notice Contract responsible for creating the tokenURI */
    ITokenURIBuilder public uriBuilder;

    /**
    @notice Sets the address of the tokenURI builder contract.
     */
    function setTokenURIBuilder(address _tokenUriBuilder) external onlyOwner {
        uriBuilder = ITokenURIBuilder(_tokenUriBuilder);
    }

    /** @notice Contract responsible for creating random images */
    IRandom public random;

    /**
    @notice Sets the address of the random provider contract.
     */
    function setRandom(address _random) external onlyOwner {
        random = IRandom(_random);
    }

    /**
    @notice Retrieves the token data URI for a given token ID. Includes both the image and its accompanying metadata.
    @param tokenId Token ID referring to an existing CryptoDickbutts NFT Token ID
    */
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        uint8[] memory meta = metadata.getMetadata(tokenId);
        if (meta.length == 0) revert URIQueryForNonExistentToken(tokenId);

        string memory imageUri = builder.getImage(renderer, encoder, meta);
        (uint256 width, uint256 height) = builder.getCanonicalSize();
        string memory imageDataUri = svgWrapper.getWrappedImage(
            imageUri,
            width,
            height
        );

        return
            uriBuilder.build(
                metadata,
                strings,
                tokenId,
                imageUri,
                imageDataUri,
                DESCRIPTION,
                EXTERNAL_URL,
                PREFIX,
                meta
            );
    }

    /**
    @notice Retrieves a random token data URI. This generates a completely new and unofficial CryptoDickbutts.
    @param seed An unsigned 64-bit integer representing the image.
    */
    function randomTokenURI(uint64 seed) external view returns (string memory) {
        (string memory imageUri, uint8[] memory meta) = random.randomImageURI(
            seed,
            builder,
            renderer,
            encoder
        );
        (uint256 canonicalWidth, uint256 canonicalHeight) = builder
            .getCanonicalSize();
        string memory imageDataUri = svgWrapper.getWrappedImage(
            imageUri,
            canonicalWidth,
            canonicalHeight
        );
        return
            uriBuilder.build(
                metadata,
                strings,
                seed,
                imageUri,
                imageDataUri,
                DESCRIPTION,
                EXTERNAL_URL,
                PREFIX,
                meta
            );
    }

    /**
    @notice Retrieves a random image data URI. This generates a completely new and unoffical CryptoDickbutts image.
    */
    function randomImageURI(uint64 seed) external view returns (string memory) {
        (string memory imageUri, ) = random.randomImageURI(
            seed,
            builder,
            renderer,
            encoder
        );
        return imageUri;
    }

    /**
    @notice Retrieves a specific token URI built from raw metadata. This generates a user-defined Cryptodickbutt, not officially part of the collection.
    @param meta An array of unsigned 8-bit integers (bytes) to use to produce the raw image.
    @dev The data passed here is not validated, so can result in an illogical Cryptodickbutt, or rendering errors, if the format is not valid.
    */
    function buildTokenURI(uint8[] memory meta)
        external
        view
        returns (string memory)
    {
        string memory imageUri = builder.getImage(renderer, encoder, meta);
        (uint256 canonicalWidth, uint256 canonicalHeight) = builder.getCanonicalSize();
        string memory imageDataUri = svgWrapper.getWrappedImage(
            imageUri,
            canonicalWidth,
            canonicalHeight
        );
        return
            uriBuilder.build(
                metadata,
                strings,
                uint64(uint256(keccak256(abi.encodePacked(meta)))),
                imageUri,
                imageDataUri,
                DESCRIPTION,
                EXTERNAL_URL,
                PREFIX,
                meta
            );
    }

    /**
    @notice Retrieves a specific image URI built from raw metadata. This generates a user-defined Cryptodickbutt image, not officially part of the collection.
    @param meta An array of unsigned 8-bit integers (bytes) to use to produce the raw image.
    @dev The data passed here is not validated, so can result in an illogical Cryptodickbutt, or rendering errors, if the format is not valid.
    */
    function buildImageURI(uint8[] memory meta)
        external
        view
        returns (string memory)
    {
        return builder.getImage(renderer, encoder, meta);
    }
}
