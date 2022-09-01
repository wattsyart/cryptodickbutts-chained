// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.13;

library AlphaBlend {

    /**
     @notice A simplicity-focused blend, that over compensates alpha to "good enough" values, with error trending towards saturation.
     */
    function alpha_composite_default(uint32 bg, uint32 fg)
        internal
        pure
        returns (uint32)
    {
        uint32 r1 = bg >> 16;
        uint32 g1 = bg >> 8;
        uint32 b1 = bg;

        uint32 r2 = fg >> 16;
        uint32 g2 = fg >> 8;
        uint32 b2 = fg;

        uint32 a = ((fg >> 24) & 0xFF) + 1;
        uint32 na = 257 - a;

        uint32 r = (a * (r2 & 0xFF) + na * (r1 & 0xFF)) >> 8;
        uint32 g = (a * (g2 & 0xFF) + na * (g1 & 0xFF)) >> 8;
        uint32 b = (a * (b2 & 0xFF) + na * (b1 & 0xFF)) >> 8;

        uint32 rgb;
        rgb |= uint32(0xFF) << 24;
        rgb |= r << 16;
        rgb |= g << 8;
        rgb |= b;

        return rgb;
    }

    uint32 public constant ALPHA_MASK = 0xFF000000;
    uint32 public constant RED_BLUE_MASK = 0x00FF00FF;
    uint32 public constant GREEN_MASK = 0x0000FF00;
    uint32 public constant ALPHA_GREEN_MASK = ALPHA_MASK | GREEN_MASK;
    uint32 public constant ONE_OVER_ALPHA_MASK = 0x01000000;

    /**
     @notice An speed-focus blend that calculates red and blue channels simultaneously, with error trending to black.
     @dev Based on: https://stackoverflow.com/a/27141669
     */
    function alpha_composite_fast(uint32 bg, uint32 fg)
        internal
        pure
        returns (uint32)
    {
        uint32 a = (fg & ALPHA_MASK) >> 24;
        uint32 na = 255 - a;
        uint32 rb = ((na * (bg & RED_BLUE_MASK)) + (a * (fg & RED_BLUE_MASK))) >> 8;
        uint32 ag = (na * ((bg & ALPHA_GREEN_MASK) >> 8)) + (a * (ONE_OVER_ALPHA_MASK | ((fg & GREEN_MASK) >> 8)));
        return ((rb & RED_BLUE_MASK) | (ag & ALPHA_GREEN_MASK));
    }

    uint32 public constant PRECISION_BITS = 7;

    struct rgba {
        uint8 r;
        uint8 g;
        uint8 b;
        uint8 a;
    }

    /**
     @notice An accuracy-focused blend that rounds results after calculating values for each channel using both alpha values.
     @dev Ported from https://github.com/python-pillow/Pillow/blob/main/src/libImaging/AlphaComposite.c
     */
    function alpha_composite_pillow(uint32 bg, uint32 fg)
        internal
        pure
        returns (uint32)
    {
        unchecked {
            rgba memory dst = rgba(uint8(bg >> 16), uint8(bg >> 8), uint8(bg), uint8(bg >> 24));
            rgba memory src = rgba(uint8(fg >> 16), uint8(fg >> 8), uint8(fg), uint8(fg >> 24));

            uint outa255 = src.a * 255 + dst.a * (255 - src.a);
            uint coef1 = src.a * 255 * 255 * (1 << PRECISION_BITS) / outa255;
            uint coef2 = 255 * (1 << PRECISION_BITS) - coef1;

            uint r1 = src.r * coef1 + dst.r * coef2 + (0x80 << PRECISION_BITS);
            uint g1 = src.g * coef1 + dst.g * coef2 + (0x80 << PRECISION_BITS);
            uint b1 = src.b * coef1 + dst.b * coef2 + (0x80 << PRECISION_BITS);
            uint a1 = outa255 + 0x80;

            uint32 r = uint32((r1 >> 8) + r1) >> 8 >> PRECISION_BITS;
            uint32 g = uint32((g1 >> 8) + g1) >> 8 >> PRECISION_BITS;
            uint32 b = uint32((b1 >> 8) + b1) >> 8 >> PRECISION_BITS; 
            uint32 a = uint32((a1 >> 8) + a1) >> 8;
            
            uint32 rgb;
            rgb |= uint8(a << 24);
            rgb |= uint8(r << 16);
            rgb |= uint8(g << 8);
            rgb |= uint8(b);

            return rgb;
        }   
    }
}
