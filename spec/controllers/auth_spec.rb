require_relative "../spec_helper"

RSpec.describe App::Controllers::Auth do
  describe "#create" do
    subject(:response) { App::Controllers::Auth.new.create(request) }
    let(:valid_account) { instance_double("Auth::Account", id: 1, email: "account@example.com", authenticate: true) }
    let(:invalid_account) { instance_double("Auth::Account", id: 2, email: "account@example.com", authenticate: false) }

    let(:valid_token) { "valid_token" }

    before do
      allow(App::Repositories::Auth).to receive(:new).and_return(repository)
      allow(App::Services::Auth::JsonWebToken).to receive(:encode).with({account_id: valid_account.id}).and_return(valid_token)
    end

    context "when the account exists and authentication succeeds" do
      let(:repository) { instance_double("App::Repositories::Auth", find_by_email!: valid_account) }
      let(:request) { instance_double("Rack::Request", body: double("body", read: '{"email": "account@example.com", "password": "secure_password"}')) }

      it "returns a success response with a valid token" do
        expect(response).to eq([
          201,
          {"content-type" => "text/plain"},
          [{token: valid_token, exp: (Time.now + 86400).strftime("%m-%d-%Y %H:%M")}.to_json]
        ])
      end
    end

    context "when the account exists but authentication fails" do
      let(:repository) { instance_double("App::Repositories::Auth", find_by_email!: invalid_account) }
      let(:request) { instance_double("Rack::Request", body: double("body", read: '{"email": "account@example.com", "password": "wrong_password"}')) }

      it "returns an unauthorized response" do
        expect(response).to eq([401, {"content-type" => "text/plain"}, ["Unauthorized"]])
      end
    end

    context "when the account does not exist" do
      let(:repository) { instance_double("App::Repositories::Auth") }
      let(:request) { instance_double("Rack::Request", body: double("body", read: '{"email": "non_existent@example.com", "password": "password"}')) }

      before do
        allow(repository).to receive(:find_by_email!).and_raise(::App::Repositories::RecordNotFound)
      end

      it "returns an unauthorized response" do
        expect(response).to eq([401, {"content-type" => "text/plain"}, ["Unauthorized"]])
      end
    end
  end
end
