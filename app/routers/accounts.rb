require_relative "../controllers/accounts"
module App
  module Routers
    class Accounts
      def call(env)
        request = Rack::Request.new(env)

        case request.path_info
        when "/accounts"
          case request.request_method
          when "GET"
            Controllers::Accounts.new.index(request)
          when "POST"
            Controllers::Accounts.new.create(request)
          else
            [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
          end
        when %r{/accounts/(\d+)}
          account_id = $1.to_i
          case request.request_method
          when "GET"
            Controllers::Accounts.new.read(request, account_id)
          when "PUT"
            Controllers::Accounts.new.update(request, account_id)
          else
            [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
          end
        else
          [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
        end
      end
    end
  end
end
