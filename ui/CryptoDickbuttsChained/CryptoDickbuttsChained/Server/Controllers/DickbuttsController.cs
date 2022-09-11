using CryptoDickbuttsChained.Shared;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace CryptoDickbuttsChained.Server.Controllers
{
    [ApiController]
    [Route("dickbutts")]
    public class DickbuttsController : ControllerBase
    {
        private readonly IOptionsSnapshot<Web3Options> _options;
        private readonly ILogger<DickbuttsController> _logger;

        public DickbuttsController(IOptionsSnapshot<Web3Options> options, ILogger<DickbuttsController> logger)
        {
            _options = options;
            _logger = logger;
        }

        [HttpGet("tokenURI/{tokenId}")]
        public async Task<string> GetCanonicalTokenUri(uint tokenId)
        {
            return await DickbuttsService.GetCanonicalTokenURIAsync(tokenId, _options.Value.OnChainRpcUrl, _options.Value.OnChainContractAddress, _logger);
        }
        
        [HttpGet("random/{seed}")]
        public async Task<string> GetRandomTokenURIFromSeed(string seed)
        {
            return await DickbuttsService.GetRandomTokenURIFromSeedAsync(seed, _options.Value.OnChainRpcUrl, _options.Value.OnChainContractAddress, _logger);
        }
        
        [HttpPost("build")]
        public async Task<string> BuildTokenURI([FromBody] Dickbutt dickbutt)
        {
            return await DickbuttsService.BuildTokenURIAsync(dickbutt, _options.Value.OnChainRpcUrl, _options.Value.OnChainContractAddress, _logger);
        }
    }
}