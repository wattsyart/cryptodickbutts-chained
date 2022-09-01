// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.13;

contract CryptoDickbuttsStrings {

    mapping(uint8 => string) strings;

    function getString(uint8 key) external view returns (string memory) {
        if(key >= 204 && key <= 213) return strings[255]; // None
        return strings[key];
    }

    constructor() {
        // Background (9)
        strings[3] = "Grassy Knoll";
        strings[5] = "Picnic Day";
        strings[4] = "Ocean Mist";
        strings[7] = "Stone Grey";
        strings[8] = "Sunset";
        strings[0] = "Buds";
        strings[6] = "Puls";
        strings[1] = "Denza";
        strings[2] = "Denza2";

        // Skin (11)
        strings[194] = "Mid";
        strings[199] = "Zombie";
        strings[190] = "Ape";
        strings[191] = "Dark";
        strings[193] = "Light";
        strings[189] = "Alien";
        strings[198] = "Vampire";
        strings[197] = "Skeleton";
        strings[192] = "Ghost";
        strings[196] = "Robot";
        strings[195] = "Rainbow";

        // Body (19)
        strings[18] = "Overalls";
        strings[9] = "Backpack";
        strings[10] = "Ballerina";
        strings[17] = "Mankini";
        strings[27] = "Vampire Cape";
        strings[12] = "Bikini";
        strings[15] = "Chest Hair";
        strings[13] = "Boxers";
        strings[23] = "Sash";
        strings[24] = "Tracksuit";
        strings[25] = "Trenchcoat";
        strings[20] = "Peed Pants";
        strings[11] = "Bee Wings";
        strings[26] = "Tuxedo";
        strings[22] = "Ruffles";
        strings[19] = "Pasties";
        strings[16] = "Jumpsuit";
        strings[21] = "Pox";

        // Hat (53)
        strings[140] = "Sanchez";
        strings[101] = "Afro";
        strings[149] = "Trucker";
        strings[119] = "Fez";
        strings[109] = "Bunny";
        strings[106] = "Birthday Hat";
        strings[122] = "Hero";
        strings[131] = "Mullet";
        strings[124] = "Jester";
        strings[120] = "Franky";
        strings[108] = "Bowl Cut";
        strings[115] = "Cute Ears";
        strings[153] = "Your Future";
        strings[146] = "Swimming Cap";
        strings[144] = "Straw Hat";
        strings[103] = "Army";
        strings[130] = "Mohawk";
        strings[141] = "Santa";
        strings[128] = "Marge";
        strings[105] = "Beret";
        strings[129] = "Miner";
        strings[118] = "Exposed Brain";
        strings[127] = "Long Hair";
        strings[148] = "Toque";
        strings[123] = "Horns";
        strings[110] = "Buns";
        strings[112] = "Captain";
        strings[126] = "Leeloo";
        strings[125] = "Karen";
        strings[138] = "Robinhood";
        strings[152] = "Witch";
        strings[143] = "Sombrero";
        strings[137] = "Poop";
        strings[111] = "Candle";
        strings[142] = "Siren";
        strings[104] = "Balaclava";
        strings[121] = "Fur Hat";
        strings[147] = "Tinfoil";
        strings[132] = "Ogre";
        strings[114] = "Cowboy";
        strings[136] = "Plant";
        strings[133] = "Party Hat";
        strings[116] = "Detective";
        strings[107] = "Bonnet";
        strings[113] = "Cat";
        strings[151] = "Visor";
        strings[102] = "Antennae";
        strings[135] = "Pirate";
        strings[117] = "Dino";
        strings[150] = "Unicorn";
        strings[134] = "Pharaoh";
        strings[145] = "Strawberry";

        // Eyes (26)
        strings[69] = "Ski Goggles";
        strings[61] = "Heart";
        strings[64] = "Masquerade";
        strings[62] = "Hippie";
        strings[68] = "Single Lens";
        strings[51] = "Alien";
        strings[66] = "Potter";
        strings[56] = "Designer";
        strings[54] = "Clout";
        strings[74] = "Welding Mask";
        strings[72] = "Swimming Goggles";
        strings[52] = "Blindfold";
        strings[63] = "Mascara";
        strings[60] = "Green";
        strings[57] = "Eyelashes";
        strings[65] = "Nerd";
        strings[76] = "White";
        strings[59] = "Googly";
        strings[71] = "Steampunk";
        strings[53] = "Blue";
        strings[55] = "Cyborg";
        strings[75] = "White Mask";
        strings[70] = "Skull Mask";
        strings[58] = "Gas Mask";
        strings[73] = "Third Eye";

        // Mouth (5)
        strings[171] = "Drool";
        strings[172] = "Pierced";
        strings[170] = "Clown";
        strings[169] = "Cigar";

        // Nose (4)
        strings[173] = "Pierced";
        strings[174] = "Piggy";
        strings[176] = "Squid";

        // Hand (24)
        strings[78] = "Boxing Glove";
        strings[96] = "Spiked Club";
        strings[83] = "Flowers";
        strings[89] = "Lollipop";
        strings[91] = "Megaphone";
        strings[97] = "Torch";
        strings[79] = "Camera";
        strings[99] = "Wine";
        strings[92] = "Pencil";
        strings[94] = "Scythe";
        strings[88] = "Lifesaver";
        strings[90] = "Luggage";
        strings[84] = "Gavel";
        strings[95] = "Skateboard";
        strings[87] = "Keyboard";
        strings[82] = "Flamethrower";
        strings[81] = "Flag";
        strings[93] = "Pickle";
        strings[85] = "Hero's Sword";
        strings[80] = "Cardboard Sign";
        strings[98] = "Trident";
        strings[100] = "Wizard's Staff";
        strings[77] = "Baggie";

        // Shoes (13)
        strings[186] = "Roman Sandals";
        strings[182] = "Knight";
        strings[188] = "Trainers";
        strings[177] = "Basketball";
        strings[180] = "Chucks";
        strings[181] = "Gym Socks";
        strings[187] = "Socks & Sandals";
        strings[183] = "Pegleg";
        strings[179] = "Carpet";
        strings[185] = "Rollerskates";
        strings[184] = "Rocket";
        strings[178] = "Bunny Slippers";

        // Butt (4)
        strings[31] = "Wounded";
        strings[28] = "Gassy";
        strings[30] = "Reddish";

        // Dick (20)
        strings[41] = "Mushroom";
        strings[34] = "Chicken";
        strings[36] = "Elephant Trunk";
        strings[43] = "Old Sock";
        strings[40] = "Fuse";
        strings[49] = "Tentacle";
        strings[32] = "Cannon";
        strings[38] = "Flower";
        strings[45] = "Purpy";
        strings[39] = "Fox";
        strings[50] = "Umbrella";
        strings[44] = "Pierced";
        strings[33] = "Carrot";
        strings[46] = "Rocket";
        strings[37] = "Flame";
        strings[35] = "Dynamite";
        strings[42] = "Oh Canada";
        strings[47] = "Scorpion";
        strings[48] = "Spidey";

        // Special (4)
        strings[200] = "Buddy";
        strings[201] = "Cat";
        strings[202] = "Jack O'Lantern";
        strings[203] = "Shiba";

        // Legendary (14)
        strings[154] = "Bananabutt";
        strings[161] = "Dixty Nine";
        strings[159] = "Dickfits";
        strings[156] = "Cryptoad Dickbutt";
        strings[164] = "Paris";
        strings[165] = "Prototype";
        strings[155] = "Butt De Kooning";
        strings[166] = "Spider-butt";
        strings[157] = "Dicka Lisa";
        strings[163] = "Lady Libutty";
        strings[162] = "Dotbutt";
        strings[167] = "Telebutty";
        strings[158] = "Dickasus";
        strings[160] = "Dickpet";

        // None
        strings[255] = "None";
    }
}
