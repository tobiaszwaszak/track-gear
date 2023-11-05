require_relative "../spec_helper"

RSpec.describe App::Controllers::Accounts do
  let(:controller) { App::Controllers::Accounts.new }

  describe "#create" do
    subject(:response) { controller.create(request) }
    let(:account_data) { {"email" => "account@example.com", "password" => "secure_password"}.to_json }
    let(:request) { double("request", body: double("body", read: account_data)) }

    context "when the account data is valid" do
      before do
        allow_any_instance_of(::App::Contracts::Account).to receive(:call).and_return(OpenStruct.new(success?: true))
        allow_any_instance_of(::App::Repositories::Accounts).to receive(:create).and_return(true)
      end

      it "creates a new account" do
        expect(response).to eq([201, {"content-type" => "text/plain"}, ["Create"]])
      end
    end

    context "when the account data is invalid" do
      let(:error_message) { "Some error message" }

      before do
        allow_any_instance_of(::App::Contracts::Account).to receive(:call).and_return(OpenStruct.new(success?: false, errors: {email: [error_message]}))
      end

      it "returns an error" do
        expect(response).to eq([500, {"content-type" => "text/plain"}, ["Error creating account"]])
      end
    end
  end

  describe "#read" do
    subject(:response) { controller.read(request, account_id) }
    let(:request) { double("request") }

    context "when the account exists" do
      let(:account_id) { 1 }
      let(:account) { {id: account_id, email: "account@example.com", password: "secure_password"} }

      before do
        allow_any_instance_of(::App::Repositories::Accounts).to receive(:find).with(id: account_id).and_return(account)
      end

      it "returns the account data" do
        expect(response).to eq([200, {"content-type" => "application/json"}, [account.to_json]])
      end
    end

    context "when the account does not exist" do
      let(:account_id) { 1 }

      before do
        allow_any_instance_of(::App::Repositories::Accounts).to receive(:find).with(id: account_id).and_raise(App::Repositories::RecordNotFound)
      end

      it "returns a not found error" do
        expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
      end
    end
  end

  describe "#update" do
    subject(:response) { controller.update(request, account_id) }
    let(:account_id) { 1 }
    let(:account_data) { {"email" => "account@example.com", "password" => "secure_password"} }
    let(:request) { double("request", body: double("body", read: account_data.to_json)) }

    context "when the account data is valid and the account exists" do
      before do
        allow_any_instance_of(::App::Contracts::Account).to receive(:call).and_return(OpenStruct.new(account_data))
        allow_any_instance_of(::App::Repositories::Accounts).to receive(:update).and_return(true)
      end

      it "updates the account" do
        expect(response).to eq([200, {"content-type" => "text/plain"}, ["Update with ID #{account_id}"]])
      end
    end

    context "when the account data is invalid" do
      before do
        allow_any_instance_of(::App::Contracts::Account).to receive(:call).and_return(OpenStruct.new(success?: false, errors: {email: ["Some error message"]}))
      end

      it "returns an error" do
        expect(response).to eq([500, {"content-type" => "text/plain"}, ["Error updating account"]])
      end
    end

    context "when the account does not exist" do
      before do
        allow_any_instance_of(::App::Contracts::Account).to receive(:call).and_return(OpenStruct.new(account_data))
        allow_any_instance_of(::App::Repositories::Accounts).to receive(:update).and_raise(App::Repositories::RecordNotFound)
      end

      it "returns a not found error" do
        expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
      end
    end
  end
end
