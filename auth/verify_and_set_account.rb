require_relative "./repository"
require_relative "./json_web_token"
module Auth
  class Unauthorized < StandardError
  end

  class VerifyAndSetAccount
    def call(env)
      header = env["HTTP_AUTHORIZATION"]
      header = header.split(' ').last if header
      raise Auth::Unauthorized unless header

      begin
        decoded = Auth::JsonWebToken.decode(header)
        Auth::Repository.new.find(id: decoded["account_id"])
        decoded["account_id"]
      rescue Auth::RecordNotFound
        raise Auth::Unauthorized
      rescue JWT::DecodeError
        raise Auth::Unauthorized
      end
    end
  end
end
