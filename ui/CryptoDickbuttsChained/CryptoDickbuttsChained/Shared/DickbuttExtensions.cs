using CryptoDickbuttsChained.Shared.Traits;

namespace CryptoDickbuttsChained.Shared
{
    public static class DickbuttExtensions
    {
        public static Dickbutt ToDickbutt(this JsonTokenMetadata metadata)
        {
            var dickbutt = new Dickbutt();

            TrySetEnumValueMatch<Background>(dickbutt, metadata);
            TrySetEnumValueMatch<Skin>(dickbutt, metadata);
            TrySetEnumValueMatch<Body>(dickbutt, metadata);
            TrySetEnumValueMatch<Hat>(dickbutt, metadata);
            TrySetEnumValueMatch<Eyes>(dickbutt, metadata);
            TrySetEnumValueMatch<Mouth>(dickbutt, metadata);
            TrySetEnumValueMatch<Nose>(dickbutt, metadata);
            TrySetEnumValueMatch<Hand>(dickbutt, metadata);
            TrySetEnumValueMatch<Shoes>(dickbutt, metadata);
            TrySetEnumValueMatch<Butt>(dickbutt, metadata);
            TrySetEnumValueMatch<Dick>(dickbutt, metadata);
            TrySetEnumValueMatch<Special>(dickbutt, metadata);

            return dickbutt;
        }

        private static void TrySetEnumValueMatch<T>(Dickbutt dickbutt, JsonTokenMetadata metadata) where T : Enum
        {
            var propertyName = typeof(T).Name;

            var traitType = propertyName switch
            {
                _ => propertyName
            };

            var traitValue = metadata.Attributes.SingleOrDefault(x => x.TraitType == traitType)?.Value?.ToString()
                    ?.Replace(" ", "")
                    .Replace("-", "")
                    .Replace("&", "")
                ;

            foreach (var value in Enum.GetValues(typeof(T)))
            {
                if (traitValue == Enum.GetName(typeof(T), value))
                {
                    var property = typeof(Dickbutt).GetProperty(propertyName);
                    if (property != null)
                    {
                        property.SetValue(dickbutt, value);
                    }
                }
            }
        }

        public static byte[] ToMetadataBuffer(this Dickbutt dickbutt)
        {
            var buffer = new List<byte>
            {
                (byte) dickbutt.Background
            };

            buffer.Add((byte)dickbutt.Skin);
            buffer.Add((byte)dickbutt.Body);
            buffer.Add((byte)dickbutt.Hat);
            buffer.Add((byte)dickbutt.Eyes);
            buffer.Add((byte)dickbutt.Mouth);
            buffer.Add((byte)dickbutt.Nose);
            buffer.Add((byte)dickbutt.Hand);
            buffer.Add((byte)dickbutt.Shoes);
            buffer.Add((byte)dickbutt.Butt);
            buffer.Add((byte)dickbutt.Dick);
            buffer.Add((byte)dickbutt.Special);

            var meta = buffer.ToArray();
            return meta;
        }
    }
}
