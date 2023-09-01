require_relative "../db/records/strava_credential"

module StravaIntegration
  class Repository
    def create_credentials(access_token:, refresh_token:)
      Db::Records::StravaCredential.create(
        access_token: access_token,
        refresh_token: refresh_token
      )
    end

    def get_access_token
      Db::Records::StravaCredential.last.access_token
    end

    def get_refresh_token
      Db::Records::StravaCredential.last.refresh_token
    end

    def update_credentials(access_token:, refresh_token:)
      Db::Records::StravaCredential.last.update(
        access_token: access_token,
        refresh_token: refresh_token
      )
    end
  end
end
