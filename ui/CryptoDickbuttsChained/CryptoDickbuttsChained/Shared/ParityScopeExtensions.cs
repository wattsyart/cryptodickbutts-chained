namespace CryptoDickbuttsChained.Shared;

public static class ParityScopeExtensions
{
    public static uint Count(this ParityScope scope)
    {
        return (uint) TokenIds(scope).Count();
    }

    public static IEnumerable<uint> TokenIds(this ParityScope scope)
    {
        var tokenIds = scope switch
        {
            ParityScope.All => LUT.AllTokenIds,
            ParityScope.Generated => LUT.AllTokenIds.Except(LUT.LegendaryTokenIds),
            ParityScope.Legendary => LUT.LegendaryTokenIds,
            _ => throw new ArgumentOutOfRangeException()
        };

        return tokenIds;
    }

    public static ParityScope Scope(this uint tokenId)
    {
        if (ParityScope.Legendary.TokenIds().Contains(tokenId))
            return ParityScope.Legendary;

        if (ParityScope.Generated.TokenIds().Contains(tokenId))
            return ParityScope.Generated;

        throw new ArgumentOutOfRangeException($"{tokenId} has no scope");
    }
}