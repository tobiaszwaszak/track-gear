require_relative "../spec_helper"

RSpec.describe App::Repositories::Accounts do
  let(:repository) { App::Repositories::Accounts.new }

  before(:all) do
    ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
    ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
  end

  after(:all) do
    ActiveRecord::Base.remove_connection
  end

  before { ::App::Records::Account.delete_all }

  describe "#create" do
    it "creates a new account" do
      email = "account@example.com"
      password = "secure_password"

      created_account = repository.create(email: email, password: password)

      expect(created_account[:email]).to eq(email)
      expect(created_account[:id]).not_to be_nil
    end
  end

  describe "#find" do
    context "when the account exists" do
      it "returns the account data" do
        account = repository.create(email: "account@example.com", password: "secure_password")

        found_account = repository.find(id: account[:id])

        expect(found_account).to eq(account)
      end
    end

    context "when the account does not exist" do
      it "raises a RecordNotFound error" do
        non_existent_account_id = 12345

        expect { repository.find(id: non_existent_account_id) }.to raise_error(::App::Repositories::RecordNotFound)
      end
    end
  end

  describe "#find_by_email" do
    context "when the account with the given email exists" do
      it "returns the account data" do
        email = "account@example.com"
        account = repository.create(email: email, password: "secure_password")

        found_account = repository.find_by_email(email)

        expect(found_account).to eq(account)
      end
    end

    context "when the account with the given email does not exist" do
      it "returns nil" do
        non_existent_email = "non_existent@example.com"

        found_account = repository.find_by_email(non_existent_email)

        expect(found_account).to be_nil
      end
    end
  end

  describe "#update" do
    context "when the account exists" do
      it "updates the account data" do
        account = repository.create(email: "account@example.com", password: "secure_password")
        updated_data = {email: "updated_account@example.com", password: "updated_password"}

        updated_account = repository.update(id: account[:id], params: updated_data)

        expect(updated_account).to eq({id: account[:id], email: "updated_account@example.com"})
      end
    end

    context "when the account does not exist" do
      it "raises a RecordNotFound error" do
        non_existent_account_id = 12345
        account_data = {email: "updated_account@example.com"}

        expect { repository.update(id: non_existent_account_id, params: account_data) }.to raise_error(::App::Repositories::RecordNotFound)
      end
    end
  end
end
