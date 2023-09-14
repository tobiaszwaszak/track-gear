require "rspec"
require_relative "../../app/records/strava_credential"
require_relative "../../strava_integration/repository"

module StravaIntegration
  describe Repository do
    let(:repository) { Repository.new }

    before do
      ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
      ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
    end

    describe "#create_credentials" do
      it "creates Strava credentials with access and refresh tokens" do
        access_token = "test_access_token"
        refresh_token = "test_refresh_token"

        repository.create_credentials(access_token: access_token, refresh_token: refresh_token)

        credential = ::App::Records::StravaCredential.last
        expect(credential.access_token).to eq(access_token)
        expect(credential.refresh_token).to eq(refresh_token)
      end
    end

    describe "#get_access_token" do
      it "returns the access token from the latest Strava credential" do
        test_access_token = "test_access_token"
        test_refresh_token = "test_refresh_token"
        repository.create_credentials(access_token: test_access_token, refresh_token: test_refresh_token)

        expect(repository.get_access_token).to eq(test_access_token)
      end
    end

    describe "#get_refresh_token" do
      it "returns the refresh token from the latest Strava credential" do
        test_access_token = "test_access_token"
        test_refresh_token = "test_refresh_token"
        repository.create_credentials(access_token: test_access_token, refresh_token: test_refresh_token)

        expect(repository.get_refresh_token).to eq(test_refresh_token)
      end
    end

    describe "#update_credentials" do
      it "updates the access and refresh tokens of the latest Strava credential" do
        initial_access_token = "initial_access_token"
        initial_refresh_token = "initial_refresh_token"
        repository.create_credentials(access_token: initial_access_token, refresh_token: initial_refresh_token)

        updated_access_token = "updated_access_token"
        updated_refresh_token = "updated_refresh_token"
        repository.update_credentials(access_token: updated_access_token, refresh_token: updated_refresh_token)

        updated_credential = ::App::Records::StravaCredential.last
        expect(updated_credential.access_token).to eq(updated_access_token)
        expect(updated_credential.refresh_token).to eq(updated_refresh_token)
      end
    end
  end
end
