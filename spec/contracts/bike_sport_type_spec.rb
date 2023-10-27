require "dry/validation"
require_relative "../../app/contracts/bike_sport_type"

RSpec.describe App::Contracts::BikeSportType do
  subject(:contract) { described_class.new }

  describe "with valid parameters" do
    let(:valid_params) { {bike_id: 1, sport_type_id: 2} }

    it "is valid" do
      result = contract.call(valid_params)
      expect(result.success?).to be(true)
    end
  end

  describe "with missing bike_id" do
    let(:invalid_params) { {bike_id: nil, sport_type_id: 2} }

    it "is invalid" do
      result = contract.call(invalid_params)
      expect(result.failure?).to be(true)
      expect(result.errors.to_h.keys).to include(:bike_id)
    end
  end

  describe "with missing sport_type_id" do
    let(:invalid_params) { {bike_id: 1, sport_type_id: nil} }

    it "is invalid" do
      result = contract.call(invalid_params)
      expect(result.failure?).to be(true)
      expect(result.errors.to_h.keys).to include(:sport_type_id)
    end
  end

  describe "with non-integer bike_id" do
    let(:invalid_params) { {bike_id: "not_an_integer", sport_type_id: 2} }

    it "is invalid" do
      result = contract.call(invalid_params)
      expect(result.failure?).to be(true)
      expect(result.errors.to_h.keys).to include(:bike_id)
    end
  end

  describe "with non-integer sport_type_id" do
    let(:invalid_params) { {bike_id: 1, sport_type_id: "not_an_integer"} }

    it "is invalid" do
      result = contract.call(invalid_params)
      expect(result.failure?).to be(true)
      expect(result.errors.to_h.keys).to include(:sport_type_id)
    end
  end
end
