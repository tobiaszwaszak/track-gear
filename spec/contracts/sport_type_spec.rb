require "dry/validation"
require_relative "../../app/contracts/sport_type"

RSpec.describe App::Contracts::SportType do
  subject(:contract) { described_class.new }

  describe "with valid parameters" do
    let(:valid_params) { { name: "Football" } }

    it "is valid" do
      result = contract.call(valid_params)
      expect(result.success?).to be(true)
    end
  end

  describe "with missing name" do
    let(:invalid_params) { { name: nil } }

    it "is invalid" do
      result = contract.call(invalid_params)
      expect(result.failure?).to be(true)
      expect(result.errors.to_h.keys).to include(:name)
    end
  end

  describe "with empty name" do
    let(:invalid_params) { { name: "" } }

    it "is invalid" do
      result = contract.call(invalid_params)
      expect(result.failure?).to be(true)
      expect(result.errors.to_h.keys).to include(:name)
    end
  end
end
