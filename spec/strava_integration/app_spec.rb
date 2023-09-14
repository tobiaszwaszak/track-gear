require "rspec"
require "rack/test"
require_relative "../../strava_integration/app"

describe StravaIntegration::App do
  include Rack::Test::Methods
  let(:strava_oauth_double) { instance_double("Strava::OAuth::Client", authorize_url: spy, oauth_token: spy) }
  let(:repository_double) do
    instance_double(
      "App::Repositories::StravaIntegrations",
      create_credentials: spy,
      get_refresh_token: spy,
      update_credentials: spy,
      get_access_token: spy
    )
  end
  let(:strava_api_double) { instance_double("Strava::Api::Client", athlete_activities: []) }

  def app
    StravaIntegration::App.new
  end

  before(:each) do
    allow(::Strava::OAuth::Client).to receive(:new).and_return(strava_oauth_double)
    allow(App::Repositories::StravaIntegrations).to receive(:new).and_return(repository_double)
    allow(JWT).to receive(:decode).and_return([{"account_id" => 123}])
    allow(Strava::Api::Client).to receive(:new).and_return(strava_api_double)
  end

  it "performs authorizie and redirect" do
    get "/authorize"

    expect(last_response).to be_redirect
  end

  it "callback and redirect" do
    get "/callback"

    expect(last_response).to be_redirect
  end

  it "callback and redirect" do
    get "/callback"

    expect(last_response).to be_redirect
  end

  it "returns avtivities from strava" do
    get "/get_activities"

    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq([])
  end
end
