require "json"
require_relative "./../../accounts/controller"

RSpec.describe Accounts::Controller do
  let(:controller) { Accounts::Controller.new }

  describe "#create" do
    let(:account_data) { {"email" => "account@example.com", "password" => "secure_password"}.to_json }

    context "when the account data is valid" do
      it "creates a new account" do
        allow_any_instance_of(::App::Contracts::Account).to receive(:call).and_return(OpenStruct.new(success?: true))
        allow_any_instance_of(::App::Repositories::Accounts).to receive(:create).and_return(true)

        request = double("request", body: double("body", read: account_data))

        response = controller.create(request)

        expect(response).to eq([201, {"content-type" => "text/plain"}, ["Create"]])
      end
    end

    context "when the account data is invalid" do
      it "returns an error" do
        error_message = "Some error message"
        allow_any_instance_of(::App::Contracts::Account).to receive(:call).and_return(OpenStruct.new(success?: false, errors: {email: [error_message]}))

        request = double("request", body: double("body", read: account_data))

        response = controller.create(request)

        expect(response).to eq([500, {"content-type" => "text/plain"}, ["Error creating account"]])
      end
    end
  end

  describe "#read" do
    context "when the account exists" do
      let(:account_id) { 1 }
      let(:account) { {id: account_id, email: "account@example.com", password: "secure_password"} }

      it "returns the account data" do
        allow_any_instance_of(::App::Repositories::Accounts).to receive(:find).with(id: account_id).and_return(account)

        request = double("request")

        response = controller.read(request, account_id)

        expect(response).to eq([200, {"content-type" => "application/json"}, [account.to_json]])
      end
    end

    context "when the account does not exist" do
      let(:account_id) { 1 }

      it "returns a not found error" do
        allow_any_instance_of(::App::Repositories::Accounts).to receive(:find).with(id: account_id).and_raise(App::Repositories::RecordNotFound)

        request = double("request")

        response = controller.read(request, account_id)

        expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
      end
    end
  end

  describe "#update" do
    let(:account_id) { 1 }
    let(:account_data) { {"email" => "account@example.com", "password" => "secure_password"} }

    context "when the account data is valid and the account exists" do
      it "updates the account" do
        allow_any_instance_of(::App::Contracts::Account).to receive(:call).and_return(OpenStruct.new(account_data))
        allow_any_instance_of(::App::Repositories::Accounts).to receive(:update).and_return(true)

        request = double("request", body: double("body", read: account_data.to_json))

        response = controller.update(request, account_id)

        expect(response).to eq([200, {"content-type" => "text/plain"}, ["Update with ID #{account_id}"]])
      end
    end

    context "when the account data is invalid" do
      it "returns an error" do
        error_message = "Some error message"
        allow_any_instance_of(::App::Contracts::Account).to receive(:call).and_return(OpenStruct.new(success?: false, errors: {email: [error_message]}))

        request = double("request", body: double("body", read: account_data.to_json))

        response = controller.update(request, account_id)

        expect(response).to eq([500, {"content-type" => "text/plain"}, ["Error updating account"]])
      end
    end

    context "when the account does not exist" do
      it "returns a not found error" do
        allow_any_instance_of(::App::Contracts::Account).to receive(:call).and_return(OpenStruct.new(account_data))
        allow_any_instance_of(::App::Repositories::Accounts).to receive(:update).and_raise(App::Repositories::RecordNotFound)

        request = double("request", body: double("body", read: account_data.to_json))

        response = controller.update(request, account_id)

        expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
      end
    end
  end
end
