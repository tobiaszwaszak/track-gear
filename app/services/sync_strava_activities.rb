require_relative "../repositories/strava_integrations"
require_relative "../repositories/activities"

module App
  class SyncStravaActivities
    def initialize
      @strava_oauth_client = ::Strava::OAuth::Client.new(
        client_id: ENV["STRAVA_CLIENT_ID"],
        client_secret: ENV["STRAVA_CLIENT_SECRET"]
      )
    end

    def call
      update_tokens
      sync_all_activities
    end

    private

    def update_tokens
      response = @strava_oauth_client.oauth_token(
        refresh_token: Repositories::StravaIntegrations.new.get_refresh_token,
        grant_type: "refresh_token"
      )

      Repositories::StravaIntegrations.new.update_credentials(
        access_token: response.access_token, refresh_token: response.refresh_token
      )
    end

    def sync_all_activities
      client = Strava::Api::Client.new(access_token: Repositories::StravaIntegrations.new.get_access_token)

      page = 1

      loop do
        activities = client.athlete_activities(page: page)
        activities.each do |activity|
          next if Repositories::Activities.new.find_by_external_id(activity["id"])
          Repositories::Activities.new.create(
            distance: activity["distance"],
            time: activity["moving_time"],
            external_id: activity["id"],
            activity_date: activity["start_date"],
            name: activity["name"],
            commute: activity["commute"],
            sport_type: activity["sport_type"]
          )
        end
        break if activities.empty?

        page += 1
      end
    end
  end
end
