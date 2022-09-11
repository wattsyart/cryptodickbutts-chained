using System.Numerics;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Logging;
using Nethereum.ABI.FunctionEncoding;
using Nethereum.ABI.FunctionEncoding.Attributes;
using Nethereum.Contracts;
using Nethereum.Contracts.Standards.ERC721.ContractDefinition;
using Nethereum.JsonRpc.Client;
using Nethereum.Web3;

namespace CryptoDickbuttsChained.Shared
{
    public static class DickbuttsService
    {
        public static async Task<string> GetCanonicalTokenURIAsync(uint tokenId, string url, string contractAddress, ILogger? logger)
        {
            var web3 = new Web3(url);
            var contract = web3.Eth.ERC721.GetContractService(contractAddress);

            try
            {
                var function = new TokenURIFunction { TokenId = tokenId };
                var tokenUri = await contract.ContractHandler.QueryAsync<TokenURIFunction, string>(function);
                return tokenUri;
            }
            catch (Exception ex)
            {
                logger?.LogError(ex, "Failed to fetch canonical token ID {TokenID}", tokenId);

                switch (ex)
                {
                    case SmartContractRevertException revert:
                        return revert.RevertMessage;
                    case RpcResponseException rpc:
                        return rpc.RpcError.Message;
                    default:
                        throw;
                }
            }
        }

        public static async Task<string> GetRandomTokenURIFromSeedAsync(string seed, string url, string contractAddress, ILogger? logger)
        {
            try
            {
                if (!ulong.TryParse(seed, out var realSeed))
                    realSeed = (ulong)new Random().NextInt64();
                var web3 = new Web3(url);
                var contract = web3.Eth.ERC721.GetContractService(contractAddress);
                var function = new RandomTokenURIFunction { Seed = realSeed };
                var tokenUri = await contract.ContractHandler.QueryAsync<RandomTokenURIFunction, string>(function);
                return tokenUri;
            }
            catch (Exception ex)
            {
                logger?.LogError(ex, "Failed to fetch random token with Seed {Seed}", seed);

                if (ex is SmartContractRevertException revert)
                {
                    return revert.RevertMessage;
                }

                if (ex is SmartContractCustomErrorRevertException customRevert)
                {
                    return customRevert.Message;
                }

                if (ex is RpcResponseException rpc)
                {
                    return rpc.RpcError.Message;
                }

                throw;
            }
        }

        public static async Task<string> BuildTokenURIAsync(Dickbutt dickbutt, string url, string contractAddress, ILogger? logger) => await BuildTokenURIFromBufferAsync(dickbutt.ToMetadataBuffer(), url, contractAddress, logger);

        public static async Task<string> BuildTokenURIFromBufferAsync(byte[] meta, string url, string contractAddress, ILogger? logger)
        {
            try
            {
                var web3 = new Web3(url);
                var contract = web3.Eth.ERC721.GetContractService(contractAddress);
                var function = new BuildTokenURIFunction { Meta = meta };
                var tokenUri = await contract.ContractHandler.QueryAsync<BuildTokenURIFunction, string>(function);

                if (tokenUri.StartsWith("data:application/json;base64,"))
                {
                    var json = tokenUri.Replace("data:application/json;base64,", "");
                    var metadata =
                        JsonSerializer.Deserialize<JsonTokenMetadata>(Encoding.UTF8.GetString(Convert.FromBase64String(json)));
                    if (metadata == null)
                        return tokenUri;

                    var metaString = Convert.ToBase64String(meta);
                    metadata.Name = $"CryptoDickbutt #{metaString}";
                    tokenUri =
                        $"data:application/json;base64,{Convert.ToBase64String(Encoding.UTF8.GetBytes(JsonSerializer.Serialize(metadata)))}";
                }

                return tokenUri;
            }
            catch (Exception ex)
            {
                logger?.LogError(ex, "Failed to fetch builder token with BuilderSeed {BuilderSeed}",
                    Convert.ToBase64String(meta));

                if (ex is SmartContractRevertException revert)
                {
                    return revert.RevertMessage;
                }

                if (ex is RpcResponseException rpc)
                {
                    return rpc.RpcError.Message;
                }

                throw;
            }
        }

        #region Functions

        [Function("randomTokenURI", "string")]
        public sealed class RandomTokenURIFunction : FunctionMessage
        {
            [Parameter("uint64", "seed", 1)]
            public BigInteger Seed { get; set; }
        }

        [Function("buildTokenURI", "string")]
        public sealed class BuildTokenURIFunction : FunctionMessage
        {
            [Parameter("uint8[]", "meta", 1)]
            public byte[] Meta { get; set; } = null!;
        }

        #endregion
    }
}
