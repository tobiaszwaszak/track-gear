require_relative "../spec_helper"

RSpec.describe App::Repositories::Auth do
  let(:repository) { App::Repositories::Auth.new }
  let(:account) { App::Records::Account.create(email: "account@example.com", password: "secure_password") }

  describe "#find" do
    it "returns the account data" do
      expect(repository.find(id: account[:id])).to eq(account)
    end

    context "when the account does not exist" do
      let(:non_existent_account_id) { 12345 }

      it "raises a RecordNotFound error" do
        expect { repository.find(id: non_existent_account_id) }.to raise_error(::App::Repositories::RecordNotFound)
      end
    end
  end

  describe "#find_by_email!" do
    let(:email) { "account@example.com" }

    before do
      account
    end

    it "returns the account" do
      found_account = repository.find_by_email!(email)
      expect(found_account.email).to eq(email)
    end

    context "when the account with the given email does not exist" do
      let(:email) { "nonexistent@example.com" }

      it "raises a RecordNotFound error" do
        expect { repository.find_by_email!(email) }.to raise_error(::App::Repositories::RecordNotFound)
      end
    end
  end
end
