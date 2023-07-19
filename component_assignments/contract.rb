require "dry/validation"

module ComponentAssignments
  class Contract < Dry::Validation::Contract
    params do
      required(:bike_id).filled(:integer)
      required(:component_id).filled(:integer)
    end
  end
end
