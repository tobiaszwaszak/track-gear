require_relative "../spec_helper"

RSpec.describe App::Contracts::Account do
  subject(:contract) { described_class.new }

  describe "validation" do
    let(:params) { {email: "account@example.com", password: "secure_password"} }

    it "is valid with valid attributes" do
      expect(contract.call(params)).to be_success
    end

    context "when params are without an email" do
      let(:params) { {password: "secure_password"} }

      it "is invalid" do
        expect(contract.call(params)).to be_failure
        expect(contract.call(params).errors[:email]).to include("is missing")
      end
    end

    context "when params are without a password" do
      let(:params) { {email: "account@example.com"} }

      it "is invalid " do
        expect(contract.call(params)).to be_failure
        expect(contract.call(params).errors[:password]).to include("is missing")
      end
    end

    context "when email is not unique" do
      before do
        App::Records::Account.create(email: "account@example.com", password: "secure_password")
      end

      it "is invalid" do
        expect(contract.call(params)).to be_failure
        expect(contract.call(params).errors[:email]).to include("Email has to be unique")
      end
    end
  end
end
