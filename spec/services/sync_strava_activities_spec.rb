require_relative "../spec_helper"

describe App::SyncStravaActivities do
  let(:strava_integrations_repo) { instance_double("App::Repositories::StravaIntegrations", get_refresh_token: spy) }
  let(:activities_repo) { instance_double("App::Repositories::Activities") }
  let(:strava_oauth_client) { instance_double("Strava::OAuth::Client") }
  let(:strava_api_client) { instance_double("Strava::Api::Client", athlete_activities: spy) }
  let(:sync_strava) { App::SyncStravaActivities.new }

  before do
    allow(App::Repositories::StravaIntegrations).to receive(:new).and_return(strava_integrations_repo)
    allow(App::Repositories::Activities).to receive(:new).and_return(activities_repo)
    allow(Strava::OAuth::Client).to receive(:new).and_return(strava_oauth_client)
    allow(Strava::Api::Client).to receive(:new).and_return(strava_api_client)
  end

  describe "#call" do
    it "should update tokens and sync activities" do
      expect(sync_strava).to receive(:update_tokens)
      expect(sync_strava).to receive(:sync_all_activities)
      sync_strava.call
    end
  end

  describe "#update_tokens" do
    let(:response) { double("Strava OAuth Response", access_token: "new_access_token", refresh_token: "new_refresh_token") }

    before do
      allow(strava_integrations_repo).to receive(:get_refresh_token).and_return("current_refresh_token")
      allow(strava_oauth_client).to receive(:oauth_token).and_return(response)
    end

    it "should update tokens and save them to the repository" do
      expect(strava_integrations_repo).to receive(:update_credentials).with(
        access_token: "new_access_token",
        refresh_token: "new_refresh_token"
      )
      sync_strava.send(:update_tokens)
    end
  end

  describe "#sync_all_activities" do
    let(:access_token) { "test_access_token" }
    let(:activities) do
      [
        {
          "id" => 1,
          "distance" => 10.0,
          "moving_time" => 3600,
          "start_date" => "2023-10-19T12:00:00Z",
          "name" => "Test Activity",
          "commute" => false,
          "sport_type" => "Running"
        }
      ]
    end

    before do
      allow(strava_integrations_repo).to receive(:get_access_token).and_return(access_token)
    end

    it "should sync activities from Strava API" do
      expect(strava_api_client).to receive(:athlete_activities).with(page: 1).and_return(activities)
      expect(activities_repo).to receive(:find_by_external_id).with(1).and_return(nil)
      expect(activities_repo).to receive(:create).with(
        distance: 10.0,
        time: 3600,
        external_id: 1,
        activity_date: "2023-10-19T12:00:00Z",
        name: "Test Activity",
        commute: false,
        sport_type: "Running"
      )

      sync_strava.send(:sync_all_activities)
    end
  end
end
