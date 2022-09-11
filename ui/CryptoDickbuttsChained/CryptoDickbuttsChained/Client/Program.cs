using BlazorTable;
using CryptoDickbuttsChained.Client;
using CryptoDickbuttsChained.Shared;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

builder.Services.AddBlazorTable();
builder.Services.AddScoped(_ => new HttpClient { BaseAddress = new Uri(builder.HostEnvironment.BaseAddress) });

builder.Services.Configure<Web3Options>(o =>
{
    // RPC URL pointing to the on-chain project
    o.OnChainRpcUrl = null!;

    // contract address for the on-chain project
    o.OnChainContractAddress = "0x277a9984e8636c230c348a55314594769cd63466";
    
    // contract address for mainnet project
    o.SourceContractAddress = "0x42069abfe407c60cf4ae4112bedead391dba1cdb";

    // RPC URL pointing to mainnet (used in parity testing)
    o.SourceRpcUrl = null!;
    
    // IPFS CID (used in parity testing)
    o.IpfsCid = "QmR9EWTU4JmYgHdpLza6exrwGaqpqiaZabXejWabSF3DUd";

    // IPFS gateway URL (used in parity testing)
    o.IpfsUrl = null!;

    // IPFS username (used in parity testing, optional)
    o.IpfsUsername = null!;

    // IPFS password (used in parity testing, optional)
    o.IpfsPassword = null!;

    // hide URLs in UI for sharing purposes
    o.HideSensitiveFields = false;
});

await builder.Build().RunAsync();
