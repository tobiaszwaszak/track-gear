require "dry/validation"

module Components
  class Contract < Dry::Validation::Contract
    params do
      required(:name).filled(:string)
      required(:description).filled(:string)
      optional(:bike_id).filled(:integer)
    end
  end
end
