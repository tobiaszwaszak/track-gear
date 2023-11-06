require_relative "spec_helper"

RSpec.describe AuthMiddleware do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use AuthMiddleware
      run ->(env) { [200, {"Content-Type" => "text/plain"}, ["Hello, World!"]] }
    end
  end

  describe "AuthMiddleware" do
    context "when accessing /" do
      it "allows access without authentication" do
        get "/"
        expect(last_response).to be_ok
        expect(last_response.body).to eq("Hello, World!")
      end
    end

    context "when accessing /environment" do
      it "allows access without authentication" do
        get "/environment"
        expect(last_response).to be_ok
        expect(last_response.body).to eq("Hello, World!")
      end
    end

    context "when accessing /auth" do
      it "allows access without authentication" do
        get "/auth"
        expect(last_response).to be_ok
        expect(last_response.body).to eq("Hello, World!")
      end
    end

    context "when accessing /accounts/1" do
      let(:account) { App::Repositories::Accounts.new.create(email: "foo@.bar.dev", password: "password") }
      let(:account_id) { account[:id] }
      let(:jwt_token) { App::Services::Auth::JsonWebToken.encode(account_id: account_id) }

      it "calls Auth::VerifyAndSetAccount" do
        header "Authorization", "Bearer #{jwt_token}"
        get "/accounts/#{account_id}"

        expect(last_response).to be_ok
        expect(last_request.env["account_id"]).to eq(account_id)
      end

      it "returns 401 Unauthorized without authentication" do
        get "/accounts/1"
        expect(last_response).to be_unauthorized
        expect(last_response.body).to eq("Unauthorized")
      end

      it "returns 401 Unauthorized with invalid authentication" do
        header "Authorization", "Bearer invalid_token"
        get "/accounts/1"

        expect(last_response).to be_unauthorized
        expect(last_response.body).to eq("Unauthorized")
      end

      context "when account not exist" do
        let(:account_id) { 9999 }

        it "returns 401 Unauthorized for non-existing accounts" do
          header "Authorization", "Bearer #{jwt_token}"
          get "/accounts/1"

          expect(last_response).to be_unauthorized
          expect(last_response.body).to eq("Unauthorized")
        end
      end
    end

    context "when accessing /accounts (POST)" do
      it "allows access without authentication" do
        post "/accounts", {}
        expect(last_response).to be_ok
        expect(last_response.body).to eq("Hello, World!")
      end
    end

    context "when accessing unknown paths" do
      it "returns 401 Unauthorized" do
        get "/unknown"
        expect(last_response).to be_unauthorized
        expect(last_response.body).to eq("Unauthorized")
      end
    end
  end
end
