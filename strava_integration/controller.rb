require "strava-ruby-client"
require "jwt"
require_relative "repository"
require "byebug"
module StravaIntegration
  class Controller
    def initialize
      @strava_client = ::Strava::OAuth::Client.new(
        client_id: ENV["STRAVA_CLIENT_ID"],
        client_secret: ENV["STRAVA_CLIENT_SECRET"]
      )
    end

    def authorize(request)
      user_token = generate_user_token(request.env["account_id"])
      redirect_to_strava_authorize_url(user_token)
    end

    def callback(request)
      switch_to_proper_db(request)

      response = exchange_code_for_oauth_token(request.params["code"])

      StravaIntegration::Repository.new.create_credentials(
        access_token: response.access_token, refresh_token: response.refresh_token
      )

      [302, {"Location" => "/"}, []]
    end

    private

    def generate_user_token(account_id)
      payload = {
        account_id: account_id,
        exp: (Time.now + 900).to_i
      }
      JWT.encode(payload, ENV["SECRET_KEY"])
    end

    def switch_to_proper_db(request)
      token = request.params["user_token"]
      decoded = JWT.decode(token, ENV["SECRET_KEY"])[0]
      tenant_id = decoded["account_id"]
      establish_db_connection(tenant_id)
    end

    def redirect_to_strava_authorize_url(user_token)
      redirect_url = @strava_client.authorize_url(
        redirect_uri: "#{ENV["STRAVA_REDIRECT_URI"]}?user_token=#{user_token}",
        approval_prompt: "force",
        response_type: "code",
        scope: "activity:read_all",
        state: "magic"
      )
      puts redirect_url
      [302, {"Location" => redirect_url}, []]
    end

    def exchange_code_for_oauth_token(code)
      @strava_client.oauth_token(code: code)
    end

    def establish_db_connection(tenant_id)
      db_file = "#{ENV["DB_DIRECTORY"]}#{ENV["RACK_ENV"]}_#{tenant_id}.sqlite3"
      ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: db_file)
    end
  end
end
