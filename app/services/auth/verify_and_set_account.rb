require_relative "../../repositories/auth"
require_relative "./json_web_token"

module App
  module Services
module Auth
  class Unauthorized < StandardError
  end

  class VerifyAndSetAccount
    def call(env)
      header = env["HTTP_AUTHORIZATION"]
      header = header.split(" ").last if header
      raise Auth::Unauthorized unless header

      begin
        decoded = Auth::JsonWebToken.decode(header)
        Repositories::Auth.new.find(id: decoded["account_id"])
        decoded["account_id"]
      rescue Repositories::RecordNotFound
        raise Auth::Unauthorized
      rescue JWT::DecodeError
        raise Auth::Unauthorized
      end
    end
  end
end
end
end
