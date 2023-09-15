require "dry/validation"

module App
  module Contracts
    class ComponentAssignment < Dry::Validation::Contract
      params do
        required(:bike_id).filled(:integer)
        required(:component_id).filled(:integer)
      end
    end
  end
end
