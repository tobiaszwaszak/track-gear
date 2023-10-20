require_relative "../records/strava_credential"

module App
  module Repositories
    class StravaIntegrations
      def create_credentials(access_token:, refresh_token:)
        Records::StravaCredential.create!(
          access_token: access_token,
          refresh_token: refresh_token
        )
      end

      def get_access_token
        Records::StravaCredential.last.access_token
      end

      def get_refresh_token
        Records::StravaCredential.last.refresh_token
      end

      def update_credentials(access_token:, refresh_token:)
        Records::StravaCredential.last.update(
          access_token: access_token,
          refresh_token: refresh_token
        )
      end
    end
  end
end
