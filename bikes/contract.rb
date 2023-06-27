require "dry/validation"

module Bikes
  class Contract < Dry::Validation::Contract
    include ActiveModel::Model

    params do
      required(:name).filled(:string)
    end
  end
end
