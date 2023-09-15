require_relative "../app/controllers/strava_integrations"
module StravaIntegration
  class App
    def call(env)
      request = Rack::Request.new(env)

      if request.path.include?("/authorize") && request.request_method == "GET"
        ::App::Controllers::StravaIntegrations.new.authorize(request)
      elsif request.path.include?("/callback") && request.request_method == "GET"
        ::App::Controllers::StravaIntegrations.new.callback(request)
      elsif request.path.include?("/get_activities") && request.request_method == "GET"
        ::App::Controllers::StravaIntegrations.new.get_activities(request)
      else
        [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
      end
    end
  end
end
