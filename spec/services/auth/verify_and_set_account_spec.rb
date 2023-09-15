require_relative "../../../app/services/auth/verify_and_set_account"
require_relative "../../../app/repositories/auth"
require "dotenv"

Dotenv.load(".env.test")

RSpec.describe App::Services::Auth::VerifyAndSetAccount do
  before(:all) do
    ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
    ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
  end

  after(:all) do
    ActiveRecord::Base.remove_connection
  end

  let(:account) { ::App::Records::Account.create(email: "foo@bar.dev", password: "password") }
  let(:valid_token) { App::Services::Auth::JsonWebToken.encode(account_id: account.id) }
  let(:invalid_token) { "invalid_token" }

  describe "#call" do
    context "with a valid authorization header" do
      let(:env) { {"HTTP_AUTHORIZATION" => "Bearer #{valid_token}"} }

      it "verifies and sets the account_id in the env" do
        expect_any_instance_of(App::Repositories::Auth).to receive(:find).with(id: account.id)
        result = subject.call(env)
        expect(result).to eq(account.id)
      end
    end

    context "with an invalid authorization header" do
      let(:env) { {"HTTP_AUTHORIZATION" => "Bearer #{invalid_token}"} }

      it "raises Auth::Unauthorized" do
        expect { subject.call(env) }.to raise_error(App::Services::Auth::Unauthorized)
      end
    end

    context "with no authorization header" do
      let(:env) { {} }

      it "raises Auth::Unauthorized" do
        expect { subject.call(env) }.to raise_error(App::Services::Auth::Unauthorized)
      end
    end

    context "with JWT decode error" do
      let(:env) { {"HTTP_AUTHORIZATION" => "Bearer invalid_token"} }

      before do
        allow(App::Services::Auth::JsonWebToken).to receive(:decode).and_raise(JWT::DecodeError)
      end

      it "raises Auth::Unauthorized" do
        expect { subject.call(env) }.to raise_error(App::Services::Auth::Unauthorized)
      end
    end

    context "with ::App::Repositories::RecordNotFound" do
      let(:env) { {"HTTP_AUTHORIZATION" => "Bearer #{valid_token}"} }

      before do
        allow_any_instance_of(App::Repositories::Auth).to receive(:find).and_raise(::App::Repositories::RecordNotFound)
      end

      it "raises Auth::Unauthorized" do
        expect { subject.call(env) }.to raise_error(App::Services::Auth::Unauthorized)
      end
    end
  end
end