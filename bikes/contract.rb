require "dry/validation"

module Bikes
  class Contract < Dry::Validation::Contract
    params do
      required(:name).filled(:string)
    end
  end
end
