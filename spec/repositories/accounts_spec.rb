require_relative "../spec_helper"

RSpec.describe App::Repositories::Accounts do
  let(:repository) { App::Repositories::Accounts.new }
  let(:email) { "account@example.com" }
  let(:password) { "secure_password" }
  let(:account) { repository.create(email: email, password: password) }

  describe "#create" do
    subject(:created_account) { repository.create(email: email, password: password) }

    it "creates a new account" do
      expect(created_account[:email]).to eq(email)
      expect(created_account[:id]).not_to be_nil
    end
  end

  describe "#find" do
    subject(:find_account) { repository.find(id: account[:id]) }

    it "returns the account data" do
      expect(find_account).to eq(account)
    end

    context "when the account does not exist" do
      it "raises a RecordNotFound error" do
        expect { repository.find(id: 12345) }.to raise_error(::App::Repositories::RecordNotFound)
      end
    end
  end

  describe "#find_by_email" do
    before { account }

    context "when the account with the given email exists" do
      it "returns the account data" do
        expect(repository.find_by_email(email)).to eq(account)
      end
    end

    context "when the account with the given email does not exist" do
      it "returns nil" do
        expect(repository.find_by_email("non_existent@example.com")).to be_nil
      end
    end
  end

  describe "#update" do
    subject(:update_account) { repository.update(id: request_account, params: updated_data) }
    let(:request_account) { account[:id] }
    let(:updated_data) { {email: "updated_account@example.com", password: "updated_password"} }

    it "updates the account data" do
      expect(update_account).to eq({id: account[:id], email: "updated_account@example.com"})
    end

    context "when the account does not exist" do
      let(:request_account) { 12345 }

      it "raises a RecordNotFound error" do
        expect { update_account }.to raise_error(::App::Repositories::RecordNotFound)
      end
    end
  end
end
