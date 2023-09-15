require "rack"
require_relative "./app/services/auth/verify_and_set_account"
class AuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    return @app.call(env) if req.path == "/"
    return @app.call(env) if req.path == "/environment"
    return @app.call(env) if req.path.start_with?("/auth")
    return @app.call(env) if req.path.start_with?("/accounts") && req.request_method == "POST"
    return @app.call(env) if req.path.start_with?("/strava_integration/callback")

    env["account_id"] = App::Services::Auth::VerifyAndSetAccount.new.call(env)

    @app.call(env)
  rescue App::Services::Auth::Unauthorized
    [401, {"content-type" => "text/plain"}, ["Unauthorized"]]
  end
end
