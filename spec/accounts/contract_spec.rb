require "dry/validation"
require_relative "./../../accounts/contract"

require_relative "./../../app/repositories/accounts"

RSpec.describe Accounts::Contract do
  subject(:contract) { described_class.new }

  describe "validation" do
    before do
      ::App::Records::Account.destroy_all
    end

    it "is valid with valid attributes" do
      params = {email: "account@example.com", password: "secure_password"}
      expect(contract.call(params)).to be_success
    end

    it "is invalid without an email" do
      params = {password: "secure_password"}
      expect(contract.call(params)).to be_failure
      expect(contract.call(params).errors[:email]).to include("is missing")
    end

    it "is invalid without a password" do
      params = {email: "account@example.com"}
      expect(contract.call(params)).to be_failure
      expect(contract.call(params).errors[:password]).to include("is missing")
    end

    it "is invalid if email is not unique" do
      ::App::Records::Account.create(email: "account@example.com", password: "secure_password")

      params = {email: "account@example.com", password: "secure_password"}
      expect(contract.call(params)).to be_failure
      expect(contract.call(params).errors[:email]).to include("Email has to be unique")
    end
  end
end
