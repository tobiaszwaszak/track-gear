require_relative "controller"
module StravaIntegration
  class App
    def call(env)
      request = Rack::Request.new(env)

      if request.path.include?("/authorize") && request.request_method == "GET"
        Controller.new.authorize(request)
      elsif request.path.include?("/callback") && request.request_method == "GET"
        Controller.new.callback(request)
      else
        [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
      end
    end
  end
end
