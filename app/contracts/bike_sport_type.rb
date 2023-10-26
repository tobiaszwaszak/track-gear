require "dry/validation"

module App
  module Contracts
    class BikeSportType < Dry::Validation::Contract
      params do
        required(:bike_id).filled(:integer)
        required(:sport_type_id).filled(:integer)
      end
    end
  end
end
