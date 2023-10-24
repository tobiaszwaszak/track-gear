require "dry/validation"

module App
  module Contracts
    class ComponentAssignment < Dry::Validation::Contract
      params do
        required(:bike_id).filled(:integer)
        required(:component_id).filled(:integer)
        optional(:started_at).maybe(:date_time)
        optional(:ended_at).maybe(:date_time)
      end
    end
  end
end
