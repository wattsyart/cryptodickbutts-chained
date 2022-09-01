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

    uint8 public constant canonicalSize = 54;

    mapping(uint => address) data;

    function getCanonicalSize() external override pure returns (uint, uint) {
        return (canonicalSize, canonicalSize);
    }

    function setData(uint256 key, bytes memory imageData) external onlyOwner {
        data[key] = SSTORE2.write(imageData);
    }

    /**
    @notice Returns the canonical image for the given metadata buffer, in an encoded GIF data URI format.
     */
    function getImage(IPixelRenderer renderer, IAnimationEncoder encoder, uint8[] memory metadata) external override view returns (string memory) {
        return encoder.getDataUri(_getAnimation(renderer, metadata));
    }

    function _getAnimation(IPixelRenderer renderer, uint8[] memory metadata) private view returns (Animation memory animation) {
        animation.width = canonicalSize;
        animation.height = canonicalSize;
        animation.frames = new AnimationFrame[](1);

        AnimationFrame memory frame;
        frame.width = animation.width;
        frame.height = animation.height;
        frame.buffer = new uint32[](frame.width * frame.height);

        for (uint8 i = 0; i < metadata.length; i++) {
            uint position;
            uint8 offsetX;
            uint8 offsetY;

            address feature = data[metadata[i]];
            if(feature == address(0)) continue;

            bytes memory buffer = SSTORE2.read(feature);
            (offsetX, position) = _readByte(position, buffer);
            (offsetY, position) = _readByte(position, buffer);
            _renderFrame(renderer, frame, buffer, position, offsetX, offsetY, true);
        }

        animation.frames[animation.frameCount++] = frame;
    }

    function _readByte(uint256 position, bytes memory buffer) private pure returns (uint8, uint256) {
        uint8 value = uint8(buffer[position++]);
        return (value, position);
    }

    function _renderFrame(IPixelRenderer renderer, AnimationFrame memory frame, bytes memory buffer, uint256 position, uint8 offsetX, uint8 offsetY, bool blend) private pure returns (uint256) {
        (uint32[] memory colors, uint256 positionAfterColor) = renderer.getColorTable(buffer, position);
        position = positionAfterColor;

        (uint32[] memory newBuffer, uint256 positionAfterDraw) = renderer.drawFrameWithOffsets(DrawFrame(buffer,position,frame,colors,offsetX,offsetY,blend));
        frame.buffer = newBuffer;
        return positionAfterDraw;
    }
}
