using System.ComponentModel;

namespace CryptoDickbuttsChained.Shared.Traits
{
    public enum Background : byte
    {
        [Description("None")]
        None = 203, 
        [Description("Grassy Knoll")]
        GrassyKnoll = 2,
        [Description("Picnic Day")]
        PicnicDay = 4,
        [Description("Ocean Mist")]
        OceanMist = 3,
        [Description("Stone Grey")]
        StoneGrey = 6,
        [Description("Sunset")]
        Sunset = 7,
        [Description("Buds")]
        Buds = 0,
        [Description("Puls")]
        Puls = 5,
        [Description("Denza")]
        Denza = 1
    }
}
