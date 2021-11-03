# iom-encrypt

This is intented to be simple to use like laravel's `APP_KEY=`, `decrypt` and `encrypt` helpers.
It is not drop-in compatible with laravel (PR welcome).
I use this to store encrypted values as strings in postgres.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     iom-encrypt:
       github: iomcr/iom-encrypt
   ```

2. Run `shards install`

## Usage

```crystal
require "iom-encrypt"

e = Iom::Encrypt::Encrypter.new(key: "abc");
p e.encrypt("a string")
# Unhandled exception: Key length too short: wanted 32, got 3 (ArgumentError)

e = Iom::Encrypt::Encrypter.new(key: "abcdefghijklmnopqrstuvwxyz123456");
p encrypted_value = e.encrypt("a string")
# Iom::Encrypt::EncryptedValue(@iv="\xC9 2\xA0p[L\f\x98\x89\xE0\u0013\t\u000E\xBC=", @value="\u0016m\xB9\x90h\xBB\xE9E\xECzf\u001E=\xED49", @mac="o\u0017e)\xE4\x91a\u0006N\xBA-\xFD3\x88\x9E֠\"3U\x874ikǸ\"m\u001A\u0016!\u000F")

p j2 = encrypted_value.to_base64_json
# "{\"iv\":\"ySAyoHBbTAyYieATCQ68PQ==\\n\",\"value\":\"Fm25kGi76UXsemYePe00OQ==\\n\",\"mac\":\"bxdlKeSRYQZOui39M4ie1qAiM1WHNGlrx7gibRoWIQ8=\\n\"}"

p ev1 = Iom::Encrypt::EncryptedValue.from_base64_json j2
# om::Encrypt::EncryptedValue(@iv="\xC9 2\xA0p[L\f\x98\x89\xE0\u0013\t\u000E\xBC=", @value="\u0016m\xB9\x90h\xBB\xE9E\xECzf\u001E=\xED49", @mac="o\u0017e)\xE4\x91a\u0006N\xBA-\xFD3\x88\x9E֠\"3U\x874ikǸ\"m\u001A\u0016!\u000F")

p e.decrypt(ev1)
# "a string"

p e.decrypt(j2)
# "a string"
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/iom-encrypt/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [your-name-here](https://github.com/your-github-user) - creator and maintainer
