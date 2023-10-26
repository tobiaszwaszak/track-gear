require "dry/validation"

module App
  module Contracts
    class SportType < Dry::Validation::Contract
      params do
        required(:name).filled(:string)
      end
    end
  end
end
