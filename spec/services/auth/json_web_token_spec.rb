require_relative "../../spec_helper"

RSpec.describe App::Services::Auth::JsonWebToken do
  let(:payload) { {account_id: 1} }
  let(:secret_key) { "test_secret_key" }

  before do
    allow(ENV).to receive(:[]).with("SECRET_KEY").and_return(secret_key)
  end

  describe ".encode" do
    let(:expiration_time) { 12.hours.from_now }
    let(:encoded_token) { "encoded_token" }
    let(:default_expiration_time) { 24.hours.from_now }
    it "encodes the payload with an expiration time" do
      expect(JWT).to receive(:encode).with({account_id: 1, exp: expiration_time.to_i}, secret_key).and_return(encoded_token)

      token = App::Services::Auth::JsonWebToken.encode(payload, expiration_time)

      expect(token).to eq(encoded_token)
    end

    it "encodes the payload with the default expiration time" do
      expect(JWT).to receive(:encode).with({account_id: 1, exp: default_expiration_time.to_i}, secret_key).and_return(encoded_token)

      token = App::Services::Auth::JsonWebToken.encode(payload)

      expect(token).to eq(encoded_token)
    end
  end

  describe ".decode" do
    let(:encoded_token) { "encoded_token" }
    let(:decoded_payload) { {account_id: 1} }

    it "decodes the token and returns the payload as a HashWithIndifferentAccess" do
      expect(JWT).to receive(:decode).with(encoded_token, secret_key).and_return([decoded_payload])

      payload = App::Services::Auth::JsonWebToken.decode(encoded_token)

      expect(payload).to be_a(HashWithIndifferentAccess)
      expect(payload).to eq(decoded_payload.with_indifferent_access)
    end
  end
end
