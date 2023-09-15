require "jwt"

module App
  module Services
    module Auth
      class JsonWebToken
        def self.encode(payload, exp = 24.hours.from_now)
          payload[:exp] = exp.to_i
          JWT.encode(payload, ENV["SECRET_KEY"])
        end

        def self.decode(token)
          decoded = JWT.decode(token, ENV["SECRET_KEY"])[0]
          HashWithIndifferentAccess.new decoded
        end
      end
    end
  end
end
