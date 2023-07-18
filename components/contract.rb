require "dry/validation"

module Components
  class Contract < Dry::Validation::Contract
    params do
      required(:name).filled(:string)
      optional(:brand).value(:string)
      optional(:model).value(:string)
      optional(:weight).value(:float)
      optional(:notes).value(:string)
    end
  end
end
