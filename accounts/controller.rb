require_relative "../app/repositories/accounts"
require_relative "./contract"

module Accounts
  class Controller
    def create(request)
      account_data = Accounts::Contract.new.call(JSON.parse(request.body.read))
      if account_data.errors.to_h.any?
        [500, {"content-type" => "text/plain"}, ["Error creating account"]]
      else
        account = ::App::Repositories::Accounts.new.create(
          email: account_data["email"],
          password: account_data["password"]
        )
        if account
          [201, {"content-type" => "text/plain"}, ["Create"]]
        else
          [500, {"content-type" => "text/plain"}, ["Error creating account"]]
        end
      end
    end

    def read(request, account_id)
      account = ::App::Repositories::Accounts.new.find(id: account_id)
      [200, {"content-type" => "application/json"}, [account.to_json]]
    rescue ::App::Repositories::RecordNotFound
      [404, {"content-type" => "text/plain"}, ["Not Found"]]
    end

    def update(request, account_id)
      account_data = Accounts::Contract.new.call(JSON.parse(request.body.read))
      if account_data.errors.to_h.any?
        [500, {"content-type" => "text/plain"}, ["Error updating account"]]
      elsif ::App::Repositories::Accounts.new.update(id: account_id, params: account_data.to_h)
        [200, {"content-type" => "text/plain"}, ["Update with ID #{account_id}"]]
      else
        [500, {"content-type" => "text/plain"}, ["Error updating account"]]
      end
    rescue ::App::Repositories::RecordNotFound
      [404, {"content-type" => "text/plain"}, ["Not Found"]]
    end
  end
end
