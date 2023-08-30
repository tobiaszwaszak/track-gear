require "rspec"
require "rack/test"
require_relative "../../strava_integration/app"

describe StravaIntegration::App do
  include Rack::Test::Methods
  let(:strava_double) { instance_double("Strava::OAuth::Client", authorize_url: spy, oauth_token: spy) }

  def app
    StravaIntegration::App.new
  end

  before(:each) do
    allow(::Strava::OAuth::Client).to receive(:new).and_return(strava_double)
    allow(StravaIntegration::Repository).to receive_message_chain(:new, :create_credentials).and_return(double)
    allow(JWT).to receive(:decode).and_return([{"account_id" => 123}])
  end

  it "performs authorizie and redirect" do
    get "/authorize"

    expect(last_response).to be_redirect
  end

  it "callback and redirect" do
    get "/callback"

    expect(last_response).to be_redirect
  end
end
