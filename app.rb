require "rack"
require "json"
require "./app/routers/bikes"
require "./app/routers/components"
require "./app/routers/component_assignments"
require "./app/routers/accounts"
require "./app/routers/auth"
require "./app/routers/strava_integrations"
require "./app/routers/sport_types"
require "./app/routers/bike_sport_types"

class MyApp
  def call(env)
    req = Rack::Request.new(env)
    if req.path.start_with?("/bikes")
      App::Routers::Bikes.new.call(env)
    elsif req.path.start_with?("/components")
      App::Routers::Components.new.call(env)
    elsif req.path.start_with?("/component_assignments")
      App::Routers::ComponentAssignments.new.call(env)
    elsif req.path.start_with?("/accounts")
      App::Routers::Accounts.new.call(env)
    elsif req.path.start_with?("/auth")
      App::Routers::Auth.new.call(env)
    elsif req.path.start_with?("/strava_integration")
      App::Routers::StravaIntegrations.new.call(env)
    elsif req.path.start_with?("/sport_types")
      App::Routers::SportTypes.new.call(env)
    elsif req.path.start_with?("/bike_sport_types")
      App::Routers::BikeSportTypes.new.call(env)
    else
      case req.path
      when "/"
        [200, {"content-type" => "text/html"}, [File.read("frontend/index.html")]]
      when "/environment"
        [200, {"content-type" => "text/plain"}, [ENV["RACK_ENV"]]]
      else
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end
  end
end
