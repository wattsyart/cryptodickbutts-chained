// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./lib/SSTORE2.sol";
import "./lib/graphics/Animation.sol";
import "./lib/graphics/IPixelRenderer.sol";
import "./lib/graphics/IAnimationEncoder.sol";
import "./lib/graphics/ISVGWrapper.sol";

import "./lib/interfaces/IBuilder.sol";

contract CryptoDickbuttsBuilder is Ownable, IBuilder {
    error UnexpectedTraitCount(uint256 traitCount);

    uint8 public constant canonicalSize = 54;

    mapping(uint256 => address) data;

    function getCanonicalSize()
        external
        pure
        override
        returns (uint256, uint256)
    {
        return (canonicalSize, canonicalSize);
    }

    function setData(uint256 key, bytes memory imageData) external onlyOwner {
        data[key] = SSTORE2.write(imageData);
    }

    /**
    @notice Returns the canonical image for the given metadata buffer, in an encoded data URI format.
     */
    function getImage(
        IPixelRenderer renderer,
        IAnimationEncoder encoder,
        uint8[] memory metadata
    ) external view override returns (string memory) {
        return encoder.getDataUri(_getAnimation(renderer, metadata));
    }

    function _getAnimation(IPixelRenderer renderer, uint8[] memory metadata)
        private
        view
        returns (Animation memory animation)
    {
        animation.width = canonicalSize;
        animation.height = canonicalSize;
        animation.frames = new AnimationFrame[](1);

        AnimationFrame memory frame;
        frame.width = animation.width;
        frame.height = animation.height;
        frame.buffer = new uint32[](frame.width * frame.height);

        if (metadata.length == 12) {
            _renderAttribute(renderer, frame, metadata[0]);  // background
            _renderAttribute(renderer, frame, metadata[1]);  // skin
            _renderAttribute(renderer, frame, metadata[9]);  // butt
            _renderAttribute(renderer, frame, metadata[3]);  // hat
            _renderAttribute(renderer, frame, metadata[5]);  // mouth
            _renderAttribute(renderer, frame, metadata[2]);  // body
            _renderAttribute(renderer, frame, metadata[10]); // dick
            _renderAttribute(renderer, frame, metadata[8]);  // shoes
            _renderAttribute(renderer, frame, metadata[6]);  // nose
            _renderAttribute(renderer, frame, metadata[4]);  // eyes
            _renderAttribute(renderer, frame, metadata[7]);  // hand
            _renderAttribute(renderer, frame, metadata[11]); // special
        } else if (metadata.length == 1) {
            _renderAttribute(renderer, frame, metadata[0]);  // legendary
        } else {
            revert UnexpectedTraitCount(metadata.length);
        }

        animation.frames[animation.frameCount++] = frame;
    }

    function _renderAttribute(
        IPixelRenderer renderer,
        AnimationFrame memory frame,
        uint8 attribute
    ) private view {
        uint256 position;
        uint8 offsetX;
        uint8 offsetY;

        address feature = data[attribute];
        if (feature == address(0)) return;

        bytes memory buffer = SSTORE2.read(feature);
        (offsetX, position) = _readByte(position, buffer);
        (offsetY, position) = _readByte(position, buffer);
        _renderFrame(renderer, frame, buffer, position, offsetX, offsetY, true);
    }

    function _readByte(uint256 position, bytes memory buffer)
        private
        pure
        returns (uint8, uint256)
    {
        uint8 value = uint8(buffer[position++]);
        return (value, position);
    }

    function _renderFrame(
        IPixelRenderer renderer,
        AnimationFrame memory frame,
        bytes memory buffer,
        uint256 position,
        uint8 offsetX,
        uint8 offsetY,
        bool blend
    ) private pure returns (uint256) {
        (uint32[] memory colors, uint256 positionAfterColor) = renderer
            .getColorTable(buffer, position);
        position = positionAfterColor;

        (uint32[] memory newBuffer, uint256 positionAfterDraw) = renderer
            .drawFrameWithOffsets(
                DrawFrame(
                    buffer,
                    position,
                    frame,
                    colors,
                    offsetX,
                    offsetY,
                    blend
                )
            );
        frame.buffer = newBuffer;
        return positionAfterDraw;
    }
}
