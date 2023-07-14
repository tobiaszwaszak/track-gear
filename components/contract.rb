require "dry/validation"

module Components
  class Contract < Dry::Validation::Contract
    params do
      required(:name).value(:string)
      optional(:bike_id).value(:integer)
      optional(:brand).value(:string)
      optional(:model).value(:string)
      optional(:weight).value(:float)
      optional(:notes).value(:string)
    end
  end
end
