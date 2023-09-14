require_relative "../../auth/repository"
require_relative "../../app/records/account"
require "active_record"

RSpec.describe Auth::Repository do
  before(:all) do
    ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
    ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
  end

  after(:all) do
    ActiveRecord::Base.remove_connection
  end

  let(:repository) { Auth::Repository.new }

  describe "#find" do
    context "when the account exists" do
      it "returns the account data" do
        account = ::App::Records::Account.create(email: "account@example.com", password: "secure_password")

        found_account = repository.find(id: account[:id])

        expect(found_account).to eq(account)
      end
    end

    context "when the account does not exist" do
      it "raises a RecordNotFound error" do
        non_existent_account_id = 12345

        expect { repository.find(id: non_existent_account_id) }.to raise_error(Auth::RecordNotFound)
      end
    end
  end

  describe "#find_by_email!" do
    context "when the account with the given email exists" do
      let(:email) { "account@example.com" }

      before do
        ::App::Records::Account.create(email: email, password: "password")
      end

      it "returns the account" do
        found_account = repository.find_by_email!(email)
        expect(found_account.email).to eq(email)
      end
    end

    context "when the account with the given email does not exist" do
      let(:email) { "nonexistent@example.com" }

      it "raises a RecordNotFound error" do
        expect { repository.find_by_email!(email) }.to raise_error(Auth::RecordNotFound)
      end
    end
  end
end
