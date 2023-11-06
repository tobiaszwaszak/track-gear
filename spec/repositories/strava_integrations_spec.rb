require_relative "../spec_helper"

module App::Repositories
  describe StravaIntegrations do
    let(:repository) { StravaIntegrations.new }
    let(:access_token) { "test_access_token" }
    let(:refresh_token) { "test_refresh_token" }

    before do
      repository.create_credentials(access_token: access_token, refresh_token: refresh_token)
    end
    describe "#create_credentials" do
      let(:credential) { App::Records::StravaCredential.last }

      it "creates Strava credentials with access and refresh tokens" do
        expect(credential.access_token).to eq(access_token)
        expect(credential.refresh_token).to eq(refresh_token)
      end
    end

    describe "#get_access_token" do
      it "returns the access token from the latest Strava credential" do
        expect(repository.get_access_token).to eq(access_token)
      end
    end

    describe "#get_refresh_token" do
      it "returns the refresh token from the latest Strava credential" do
        expect(repository.get_refresh_token).to eq(refresh_token)
      end
    end

    describe "#update_credentials" do
      let(:updated_access_token) { "updated_access_token" }
      let(:updated_refresh_token) { "updated_refresh_token" }
      let(:updated_credential) { App::Records::StravaCredential.last }

      before do
        repository.update_credentials(access_token: updated_access_token, refresh_token: updated_refresh_token)
      end

      it "updates the access and refresh tokens of the latest Strava credential" do
        expect(updated_credential.access_token).to eq(updated_access_token)
        expect(updated_credential.refresh_token).to eq(updated_refresh_token)
      end
    end
  end
end
