// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.13;

contract CryptoDickbuttsStrings {

    mapping(uint8 => string) strings;

    function getString(uint8 key) external view returns (string memory) {
        if(key >= 201 && key <= 210) return strings[255];
        return strings[key];
    }

    constructor() {
        // Background (8)
        strings[2] = "Grassy Knoll";
        strings[4] = "Picnic Day";
        strings[3] = "Ocean Mist";
        strings[6] = "Stone Grey";
        strings[7] = "Sunset";
        strings[0] = "Buds";
        strings[5] = "Puls";
        strings[1] = "Denza";

        // Skin (11)
        strings[193] = "Mid";
        strings[198] = "Zombie";
        strings[189] = "Ape";
        strings[190] = "Dark";
        strings[192] = "Light";
        strings[188] = "Alien";
        strings[197] = "Vampire";
        strings[196] = "Skeleton";
        strings[191] = "Ghost";
        strings[195] = "Robot";
        strings[194] = "Rainbow";

        // Body (19)
        strings[17] = "Overalls";
        strings[8] = "Backpack";
        strings[9] = "Ballerina";
        strings[16] = "Mankini";
        strings[26] = "Vampire Cape";
        strings[11] = "Bikini";
        strings[14] = "Chest Hair";
        strings[12] = "Boxers";
        strings[22] = "Sash";
        strings[23] = "Tracksuit";
        strings[24] = "Trenchcoat";
        strings[19] = "Peed Pants";
        strings[10] = "Bee Wings";
        strings[25] = "Tuxedo";
        strings[21] = "Ruffles";
        strings[18] = "Pasties";
        strings[15] = "Jumpsuit";
        strings[20] = "Pox";

        // Hat (53)
        strings[139] = "Sanchez";
        strings[100] = "Afro";
        strings[148] = "Trucker";
        strings[118] = "Fez";
        strings[108] = "Bunny";
        strings[105] = "Birthday Hat";
        strings[121] = "Hero";
        strings[130] = "Mullet";
        strings[123] = "Jester";
        strings[119] = "Franky";
        strings[107] = "Bowl Cut";
        strings[114] = "Cute Ears";
        strings[152] = "Your Future";
        strings[145] = "Swimming Cap";
        strings[143] = "Straw Hat";
        strings[102] = "Army";
        strings[129] = "Mohawk";
        strings[140] = "Santa";
        strings[127] = "Marge";
        strings[104] = "Beret";
        strings[128] = "Miner";
        strings[117] = "Exposed Brain";
        strings[126] = "Long Hair";
        strings[147] = "Toque";
        strings[122] = "Horns";
        strings[109] = "Buns";
        strings[111] = "Captain";
        strings[125] = "Leeloo";
        strings[124] = "Karen";
        strings[137] = "Robinhood";
        strings[151] = "Witch";
        strings[142] = "Sombrero";
        strings[136] = "Poop";
        strings[110] = "Candle";
        strings[141] = "Siren";
        strings[103] = "Balaclava";
        strings[120] = "Fur Hat";
        strings[146] = "Tinfoil";
        strings[131] = "Ogre";
        strings[113] = "Cowboy";
        strings[135] = "Plant";
        strings[132] = "Party Hat";
        strings[115] = "Detective";
        strings[106] = "Bonnet";
        strings[112] = "Cat";
        strings[150] = "Visor";
        strings[101] = "Antennae";
        strings[134] = "Pirate";
        strings[116] = "Dino";
        strings[149] = "Unicorn";
        strings[133] = "Pharaoh";
        strings[144] = "Strawberry";

        // Eyes (26)
        strings[68] = "Ski Goggles";
        strings[60] = "Heart";
        strings[63] = "Masquerade";
        strings[61] = "Hippie";
        strings[67] = "Single Lens";
        strings[50] = "Alien";
        strings[65] = "Potter";
        strings[55] = "Designer";
        strings[53] = "Clout";
        strings[73] = "Welding Mask";
        strings[71] = "Swimming Goggles";
        strings[51] = "Blindfold";
        strings[62] = "Mascara";
        strings[59] = "Green";
        strings[56] = "Eyelashes";
        strings[64] = "Nerd";
        strings[75] = "White";
        strings[58] = "Googly";
        strings[70] = "Steampunk";
        strings[52] = "Blue";
        strings[54] = "Cyborg";
        strings[74] = "White Mask";
        strings[69] = "Skull Mask";
        strings[57] = "Gas Mask";
        strings[72] = "Third Eye";

        // Mouth (5)
        strings[170] = "Drool";
        strings[171] = "Pierced";
        strings[169] = "Clown";
        strings[168] = "Cigar";

        // Nose (4)
        strings[172] = "Pierced";
        strings[173] = "Piggy";
        strings[175] = "Squid";

        // Hand (24)
        strings[77] = "Boxing Glove";
        strings[95] = "Spiked Club";
        strings[82] = "Flowers";
        strings[88] = "Lollipop";
        strings[90] = "Megaphone";
        strings[96] = "Torch";
        strings[78] = "Camera";
        strings[98] = "Wine";
        strings[91] = "Pencil";
        strings[93] = "Scythe";
        strings[87] = "Lifesaver";
        strings[89] = "Luggage";
        strings[83] = "Gavel";
        strings[94] = "Skateboard";
        strings[86] = "Keyboard";
        strings[81] = "Flamethrower";
        strings[80] = "Flag";
        strings[92] = "Pickle";
        strings[84] = "Hero's Sword";
        strings[79] = "Cardboard Sign";
        strings[97] = "Trident";
        strings[99] = "Wizard's Staff";
        strings[76] = "Baggie";

        // Shoes (13)
        strings[185] = "Roman Sandals";
        strings[181] = "Knight";
        strings[187] = "Trainers";
        strings[176] = "Basketball";
        strings[179] = "Chucks";
        strings[180] = "Gym Socks";
        strings[186] = "Socks & Sandals";
        strings[182] = "Pegleg";
        strings[178] = "Carpet";
        strings[184] = "Rollerskates";
        strings[183] = "Rocket";
        strings[177] = "Bunny Slippers";

        // Butt (4)
        strings[30] = "Wounded";
        strings[27] = "Gassy";
        strings[29] = "Reddish";

        // Dick (20)
        strings[40] = "Mushroom";
        strings[33] = "Chicken";
        strings[35] = "Elephant Trunk";
        strings[42] = "Old Sock";
        strings[39] = "Fuse";
        strings[48] = "Tentacle";
        strings[31] = "Cannon";
        strings[37] = "Flower";
        strings[44] = "Purpy";
        strings[38] = "Fox";
        strings[49] = "Umbrella";
        strings[43] = "Pierced";
        strings[32] = "Carrot";
        strings[45] = "Rocket";
        strings[36] = "Flame";
        strings[34] = "Dynamite";
        strings[41] = "Oh Canada";
        strings[46] = "Scorpion";
        strings[47] = "Spidey";

        // Special (3)
        strings[199] = "Buddy";
        strings[200] = "Shiba";

        // Legendary (14)
        strings[153] = "Bananabutt";
        strings[160] = "Dixty Nine";
        strings[158] = "Dickfits";
        strings[155] = "Cryptoad Dickbutt";
        strings[163] = "Paris";
        strings[164] = "Prototype";
        strings[154] = "Butt De Kooning";
        strings[165] = "Spider-butt";
        strings[156] = "Dicka Lisa";
        strings[162] = "Lady Libutty";
        strings[161] = "Dotbutt";
        strings[166] = "Telebutty";
        strings[157] = "Dickasus";
        strings[159] = "Dickpet";

        // None
        strings[255] = "None";
    }
}
