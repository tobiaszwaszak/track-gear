require_relative "../../component_assignments/contract"

RSpec.describe ComponentAssignments::Contract do
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
  end
end
