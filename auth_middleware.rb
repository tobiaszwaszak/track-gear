require "rack"
require_relative "auth/verify_and_set_account"
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

    env["account_id"] = Auth::VerifyAndSetAccount.new.call(env)

    @app.call(env)
  rescue Auth::Unauthorized
    [401, {"content-type" => "text/plain"}, ["Unauthorized"]]
  end
end
