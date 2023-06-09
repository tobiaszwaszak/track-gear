require "rack"
require "json"
require "./bikes/app"
require "./components/app"

class MyApp
  def call(env)
    req = Rack::Request.new(env)
    if req.path.start_with?("/bikes")
      Bikes::App.new.call(env)
    elsif req.path.start_with?("/components")
      Components::App.new.call(env)
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
