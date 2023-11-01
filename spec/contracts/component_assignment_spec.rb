require_relative "../spec_helper"

RSpec.describe App::Contracts::ComponentAssignment do
  subject(:contract) { described_class.new }

  describe "validations" do
    it "passes when all required parameters are provided" do
      params = {bike_id: 1, component_id: 2}
      expect(contract.call(params)).to be_success
    end

    it "fails when bike_id is missing" do
      params = {component_id: 2}
      result = contract.call(params)

      expect(result).to be_failure
      expect(result.errors.to_h).to eq({bike_id: ["is missing"]})
    end

    it "fails when component_id is missing" do
      params = {bike_id: 1}
      result = contract.call(params)

      expect(result).to be_failure
      expect(result.errors.to_h).to eq({component_id: ["is missing"]})
    end

    it "fails when bike_id is not an integer" do
      params = {bike_id: "not_an_integer", component_id: 2}
      result = contract.call(params)

      expect(result).to be_failure
      expect(result.errors.to_h).to eq({bike_id: ["must be an integer"]})
    end

    it "fails when component_id is not an integer" do
      params = {bike_id: 1, component_id: "not_an_integer"}
      result = contract.call(params)

      expect(result).to be_failure
      expect(result.errors.to_h).to eq({component_id: ["must be an integer"]})
    end

    it "pass when started_at is an datetime" do
      params = {bike_id: 1, component_id: 2, started_at: "2023-10-24 07:29:24"}
      expect(contract.call(params)).to be_success
    end

    it "pass when started_at is empty" do
      params = {bike_id: 1, component_id: 2, started_at: ""}
      expect(contract.call(params)).to be_success
    end

    it "fails when started_at is not an datetime" do
      params = {bike_id: 1, component_id: 2, started_at: "just string"}
      result = contract.call(params)

      expect(result).to be_failure
      expect(result.errors.to_h).to eq({started_at: ["must be a date time"]})
    end

    it "pass when ended_at is an datetime" do
      params = {bike_id: 1, component_id: 2, ended_at: "2023-10-24 07:29:24"}
      expect(contract.call(params)).to be_success
    end

    it "pass when ended_at is empty" do
      params = {bike_id: 1, component_id: 2, ended_at: ""}
      expect(contract.call(params)).to be_success
    end

    it "fails when ended_at is not an datetime" do
      params = {bike_id: 1, component_id: 2, ended_at: "just string"}
      result = contract.call(params)

      expect(result).to be_failure
      expect(result.errors.to_h).to eq({ended_at: ["must be a date time"]})
    end
  end
end
