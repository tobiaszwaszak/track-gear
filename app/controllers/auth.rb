require_relative "../records/account"
require_relative "../services/auth/json_web_token"
require_relative "../repositories/auth"

module App
module Controllers
  class Auth
    def create(request)
      params = JSON.parse(request.body.read)
      account = Repositories::Auth.new.find_by_email!(params["email"])
      if account&.authenticate(params["password"])
        token = Services::Auth::JsonWebToken.encode(account_id: account.id)
        time = Time.now + 86400
        response = {
          token: token,
          exp: time.strftime("%m-%d-%Y %H:%M")
        }
        [201, {"content-type" => "text/plain"}, [response.to_json]]
      else
        [401, {"content-type" => "text/plain"}, ["Unauthorized"]]
      end
    rescue Repositories::RecordNotFound
      [401, {"content-type" => "text/plain"}, ["Unauthorized"]]
    end
  end
end
end
