require "rack"
require "json"
require "./bikes/app"
class MyApp
  def call(env)
    req = Rack::Request.new(env)
    if req.path.start_with?("/bikes")
      Bikes::App.new.call(env)
    else
      case req.path
      when "/"
        [200, {"content-type" => "text/html"}, [File.read("frontend/index.html")]]
      when "/hello"
        [200, {"content-type" => "application/json"}, [{message: "Hello, World!"}.to_json]]
      else
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end
  end
end
