using TehGM.Discord.Interactions;
using TehGM.Discord.Interactions.CommandsHandling;

namespace CryptoDickbuttsChained.Server.Discord;

// ReSharper disable once UnusedMember.Global (Reflection)
public class DickbuttsCommandHandler : IDiscordInteractionCommandHandler
{
    // ReSharper disable once UnusedMember.Global
    [InteractionCommandBuilder]
    public static DiscordApplicationCommand Build()
    {
        return DiscordApplicationCommandBuilder.CreateSlashCommand("dickbutt", "returns an on-chain dickbutt")
            .AddOption(option =>
            {
                option.Name = "random";
                option.Description = "returns a random on-chain dickbutt";
                option.Type = DiscordApplicationCommandOptionType.SubCommand;

                option.AddNestedOption(n =>
                {
                    n.Name = "seed";
                    n.Type = DiscordApplicationCommandOptionType.String;
                    n.Description = "use a specific random dickbutt";
                    n.IsRequired = false;
                });
            })
            .AddOption(option =>
            {
                option.Name = "token";
                option.Description = "returns a canonical on-chain dickbutt";
                option.Type = DiscordApplicationCommandOptionType.SubCommand;

                option.AddNestedOption(n =>
                {
                    n.Name = "id";
                    n.Type = DiscordApplicationCommandOptionType.Integer;
                    n.Description = "the token ID for the desired dickbutt";
                    n.IsRequired = true;
                });
            })
            .Build();
    }

    public Task<DiscordInteractionResponse> InvokeAsync(DiscordInteraction message, HttpRequest request,
        CancellationToken cancellationToken)
    {
        var command = new DiscordInteractionResponseBuilder();

        try
        {
            uint? tokenId = null;
            if (message is { Data.Options: { } } && message.Data.TryGetIntegerOption("id", out var tokenInt))
                tokenId = (uint)tokenInt;

            if (tokenId.HasValue)
            {
                command.AddEmbed(embed =>
                {
                    embed.WithTitle($"CryptoDickbutt #{tokenId}");
                    embed.WithDescription("A small, warty, amphibious creature that resides in the metaverse.");
                    embed.WithURL($"https://cryptodickbuttschained.com/{tokenId}");
                    embed.WithImage($"https://cryptodickbuttschained.com/canonical/img/{tokenId}");
                });
            }
            else
            {
                var seed = (ulong)new Random().NextInt64();

                if (message is { Data.Options: { } } && message.Data.TryGetStringOption("seed", out var seedString) &&
                    !string.IsNullOrWhiteSpace(seedString) && long.TryParse(seedString, out var seedLong))
                    seed = (ulong)seedLong;

                command.AddEmbed(embed =>
                {
                    embed.WithTitle($"CryptoDickbutt #{seed}");
                    embed.WithDescription("A small, warty, amphibious creature that resides in the metaverse.");
                    embed.WithURL($"https://cryptodickbuttschained.com/random/{seed}");
                    embed.WithImage($"https://cryptodickbuttschained.com/random/img/{seed}");
                });
            }
        }
        catch (Exception e)
        {
            command.WithText($"Bot error: {e.Message}");
            command.WithEphemeral();
        }

        return Task.FromResult(command.Build());
    }
}