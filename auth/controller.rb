require_relative "../app/records/account"
require_relative "./json_web_token"
require_relative "./repository"
module Auth
  class Controller
    def create(request)
      params = JSON.parse(request.body.read)
      account = Auth::Repository.new.find_by_email!(params["email"])
      if account&.authenticate(params["password"])
        token = Auth::JsonWebToken.encode(account_id: account.id)
        time = Time.now + 86400
        response = {
          token: token,
          exp: time.strftime("%m-%d-%Y %H:%M")
        }
        [201, {"content-type" => "text/plain"}, [response.to_json]]
      else
        [401, {"content-type" => "text/plain"}, ["Unauthorized"]]
      end
    rescue Auth::RecordNotFound
      [401, {"content-type" => "text/plain"}, ["Unauthorized"]]
    end
  end
end
