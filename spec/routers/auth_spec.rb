require_relative "../spec_helper"

RSpec.describe App::Routers::Auth do
  include Rack::Test::Methods

  def app
    App::Routers::Auth.new
  end

  describe "POST /auth" do
    context "when creating a new authentication" do
      before do
        ::App::Records::Account.create(email: "foo@bar.dev", password: "secure_password")
      end

      it "returns a success response" do
        post "/auth", {email: "foo@bar.dev", password: "secure_password"}.to_json

        expect(last_response.status).to eq(201)
        expect(last_response.headers["Content-Type"]).to eq("text/plain")
      end
    end

    context "when using an unsupported HTTP method" do
      it "returns a Method Not Allowed response" do
        get "/auth"

        expect(last_response.status).to eq(405)
        expect(last_response.headers["Content-Type"]).to eq("text/plain")
        expect(last_response.body).to eq("Method Not Allowed")
      end
    end
  end

  describe "other endpoints" do
    it "returns a Not Found response" do
      get "/other_endpoint"

      expect(last_response.status).to eq(404)
      expect(last_response.headers["Content-Type"]).to eq("text/plain")
      expect(last_response.body).to eq("Not Found")
    end
  end
end
