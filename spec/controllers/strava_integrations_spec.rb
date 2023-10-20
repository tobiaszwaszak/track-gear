require "rspec"
require "strava-ruby-client"
require "jwt"
require "ostruct"
require_relative "../../app/controllers/strava_integrations"

class MockOAuthResponse
  attr_reader :access_token, :refresh_token

  def initialize(access_token, refresh_token)
    @access_token = access_token
    @refresh_token = refresh_token
  end
end

module App
  module Records
    class StravaCredential
      def self.create(attributes)
      end
    end
  end
end

describe App::Controllers::StravaIntegrations do
  let(:controller) { App::Controllers::StravaIntegrations.new }

  before do
    allow(::Strava::OAuth::Client).to receive(:new).and_return(double)
    allow(App::Records::StravaCredential).to receive(:create).and_return(double)
  end

  describe "#authorize" do
    it "returns a redirect URL" do
      request = double(env: {"account_id" => 123})

      allow(JWT).to receive(:encode).and_return("user_token")

      expect(controller).to receive(:redirect_to_strava_authorize_url).with("user_token").and_return([302, {"Location" => "https://www.strava.com/oauth/authorize"}, []])

      result = controller.authorize(request)

      expect(result[0]).to eq(302)
      expect(result[1]["Location"]).to include("https://www.strava.com/oauth/authorize")
    end
  end

  describe "#callback" do
    let(:request) { double(params: {"code" => "authorization_code"}) }
    before do
      allow_any_instance_of(App::Repositories::StravaIntegrations).to receive(:create_credentials).and_return({id: 1, access_token: "foo", refresh_token: "bar"})
    end

    it "exchanges the code for an OAuth token and creates a Strava credential" do
      allow(JWT).to receive(:decode).and_return([{"account_id" => 123}])

      expect(controller).to receive(:exchange_code_for_oauth_token).with("authorization_code").and_return(MockOAuthResponse.new("access_token", "refresh_token"))

      result = controller.callback(request)

      expect(result[0]).to eq(302)
      expect(result[1]["Location"]).to eq("/")
    end
  end

  describe "#establish_db_connection" do
    it "establishes a database connection" do
      expect(ActiveRecord::Base).to receive(:establish_connection).with(adapter: "sqlite3", database: "#{ENV["DB_DIRECTORY"]}#{ENV["RACK_ENV"]}_123.sqlite3")

      controller.send(:establish_db_connection, 123)
    end
  end

  describe "#sync_activities" do
    before do
      allow_any_instance_of(App::SyncStravaActivities).to receive(:call).and_return(true)
    end

    it "returns a 200 status code and JSON content type" do
      result = controller.sync_activities(double)

      expect(result[0]).to eq(200)
      expect(result[1]["content-type"]).to eq("application/json")
    end
  end
end
