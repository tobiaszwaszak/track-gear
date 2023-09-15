require_relative "../app/controllers/auth"
module Auth
  class App
    def call(env)
      request = Rack::Request.new(env)

      case request.path_info
      when "/auth"
        case request.request_method
        when "POST"
          ::App::Controllers::Auth.new.create(request)
        else
          [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
        end
      else
        [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
      end
    end
  end
end
