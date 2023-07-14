require "dry/validation"

module Bikes
  class Contract < Dry::Validation::Contract
    params do
      required(:name).filled(:string)
      optional(:brand).filled(:string)
      optional(:model).filled(:string)
      optional(:weight).filled(:float)
      optional(:notes).filled(:string)
    end
  end
end
