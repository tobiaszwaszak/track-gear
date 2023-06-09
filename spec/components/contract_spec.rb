require_relative "../../components/contract"

RSpec.describe Components::Contract do
  subject(:contract) { described_class.new }

  describe "validation rules" do
    context "when all required attributes are present" do
      let(:valid_attributes) { {name: "Handlebar", description: "High-quality handlebar"} }

      it "passes validation" do
        expect(contract.call(valid_attributes)).to be_success
      end
    end

    context "when required attributes are missing" do
      let(:invalid_attributes) { {name: "", description: "High-quality handlebar"} }

      it "fails validation" do
        expect(contract.call(invalid_attributes)).to be_failure
      end

      it "includes an error message for the missing attribute" do
        result = contract.call(invalid_attributes)
        expect(result.errors.to_h).to include(name: ["must be filled"])
      end
    end

    context "when optional attribute is not an integer" do
      let(:invalid_attributes) { {name: "Pedal", description: "Premium pedal", bike_id: "ABC"} }

      it "fails validation" do
        expect(contract.call(invalid_attributes)).to be_failure
      end

      it "includes an error message for the invalid attribute" do
        result = contract.call(invalid_attributes)
        expect(result.errors.to_h).to include(bike_id: ["must be an integer"])
      end
    end
  end
end
