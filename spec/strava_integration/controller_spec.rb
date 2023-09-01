require "rspec"
require "strava-ruby-client"
require "jwt"
require "ostruct"
require_relative "../../db/records/strava_credential"

class MockOAuthResponse
  attr_reader :access_token, :refresh_token

  def initialize(access_token, refresh_token)
    @access_token = access_token
    @refresh_token = refresh_token
  end
end

describe StravaIntegration::Controller do
  let(:controller) { StravaIntegration::Controller.new }

  before do
    allow(::Strava::OAuth::Client).to receive(:new).and_return(double)
    allow(Db::Records::StravaCredential).to receive(:create).and_return(double)
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
      expect(ActiveRecord::Base).to receive(:establish_connection).with(adapter: "sqlite3", database: "#{ENV["DB_DIRECTORY"]}test_123.sqlite3")

      controller.send(:establish_db_connection, 123)
    end
  end

  describe "#get_activities" do
    it "returns an empty array when there are no activities" do
      allow(controller).to receive(:update_tokens)
      allow(controller).to receive(:fetch_all_activities).and_return([])

      response = controller.get_activities({})

      expect(response[0]).to eq(200)
      expect(JSON.parse(response[2].first)).to eq([])
    end

    it "returns activities when there are activities" do
      allow(controller).to receive(:update_tokens)
      sample_activities = [{"id" => 1, "name" => "Activity 1"}, {"id" => 2, "name" => "Activity 2"}]
      allow(controller).to receive(:fetch_all_activities).and_return(sample_activities)

      response = controller.get_activities({})

      expect(response[0]).to eq(200)
      expect(JSON.parse(response[2].first)).to eq(sample_activities)
    end
  end
end
