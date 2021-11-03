require "./spec_helper"

describe Iom::Encrypt do
  it "base64 should be reversible" do
    random_value = Random.new.random_bytes
    Base64.decode(Base64.encode(random_value)).should eq random_value

    random_value = String.new(Random.new.random_bytes)
    Base64.decode_string(Base64.encode(random_value)).should eq random_value
  end

  it "works" do
    e = Iom::Encrypt::Encrypter.new(
      key: "RANDOM1400vat2412armAMDbobomiz44")
    value = "any string"
    ev1 = e.encrypt(value)
    j1 = ev1.to_json
    j2 = ev1.to_base64_json
    # puts j2
    ev2 = Iom::Encrypt::EncryptedValue.from_base64_json j2

    ev1.should eq ev2

    e.decrypt(ev2).should eq value
    e.decrypt(j2).should eq value
  end
end
