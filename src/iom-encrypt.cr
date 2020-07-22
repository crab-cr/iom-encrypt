require "openssl"
require "openssl/hmac"
require "json"
require "base64"
require "random"

module Iom::Encrypt
  VERSION = "0.1.0"

  struct EncryptedValue
    include JSON::Serializable
    property iv : String
    property value : String
    property mac : String

    def initialize(@iv : String, @value : String, @mac : String)
    end

    def self.from_base64_json(data : String) : self
      tmp = self.from_json(data)
      self.new(
        iv: Base64.decode_string(tmp.iv),
        value: Base64.decode_string(tmp.value),
        mac: Base64.decode_string(tmp.mac),
      )
    end

    # def to_base64 : String
    #   Base64.encode(self.to_json)
    # end

    def to_base64_json : String
      ({
        :iv    => Base64.encode(@iv),
        :value => Base64.encode(@value),
        :mac   => Base64.encode(@mac),
      }).to_json
    end
  end

  struct Encrypter
    property key : String
    property algo : String
    property hmac_algo : OpenSSL::Algorithm

    IV_SIZE = 16

    @@random = Random.new

    def initialize(
      @key : String,
      @algo = "aes-256-cbc",
      @hmac_algo = OpenSSL::Algorithm::SHA256
    )
    end

    def encrypt(data : String) : EncryptedValue
      cipher = OpenSSL::Cipher.new @algo
      cipher.encrypt
      cipher.key = @key
      cipher.iv = iv = String.new(@@random.random_bytes IV_SIZE)
      encrypted_data = IO::Memory.new
      encrypted_data.write cipher.update(data)
      encrypted_data.write cipher.final
      value = encrypted_data.to_s
      mac = String.new(OpenSSL::HMAC.digest(@hmac_algo, @key, iv + value))
      EncryptedValue.new(iv, value, mac)
    end

    def decrypt(data : String) : String
      self.decrypt EncryptedValue.from_base64 data
    end

    def decrypt(data : EncryptedValue) : String
      decipher = OpenSSL::Cipher.new @algo
      decipher.decrypt
      decipher.key = @key
      decipher.iv = data.iv
      dec_data = IO::Memory.new
      dec_data.write decipher.update(data.value)
      dec_data.write decipher.final
      dec_data.to_s
    end
  end
end
