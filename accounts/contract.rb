require "dry/validation"
require_relative "../app/repositories/accounts"

module Accounts
  class Contract < Dry::Validation::Contract
    params do
      required(:email).filled(:string)
      required(:password).filled(:string)
    end

    rule(:email) do
      key.failure("Email has to be unique") if ::App::Repositories::Accounts.new.find_by_email(value).present?
    end
  end
end
