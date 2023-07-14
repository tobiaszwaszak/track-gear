require "dry/validation"

module Bikes
  class Contract < Dry::Validation::Contract
    params do
      required(:name).value(:string)
      optional(:brand).value(:string)
      optional(:model).value(:string)
      optional(:weight).value(:float)
      optional(:notes).value(:string)
    end
  end
end
