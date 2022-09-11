using System.ComponentModel;

namespace CryptoDickbuttsChained.Shared.Traits;

public enum Skin : byte
{
    None = 0,
    [Description("Mid")]
    Mid = 186,
    [Description("Zombie")]
    Zombie = 191,
    [Description("Ape")]
    Ape = 182,
    [Description("Dark")]
    Dark = 183,
    [Description("Light")]
    Light = 185,
    [Description("Alien")]
    Alien = 181,
    [Description("Vampire")]
    Vampire = 190,
    [Description("Skeleton")]
    Skeleton = 189,
    [Description("Ghost")]
    Ghost = 184,
    [Description("Robot")]
    Robot = 188,
    [Description("Rainbow")]
    Rainbow = 187
}