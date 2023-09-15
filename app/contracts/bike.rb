require "dry/validation"
module App
  module Contracts
    class Bike < Dry::Validation::Contract
      params do
        required(:name).filled(:string)
        optional(:brand).maybe(:string)
        optional(:model).maybe(:string)
        optional(:weight).maybe(:float)
        optional(:notes).maybe(:string)
      end
    end
  end
end
