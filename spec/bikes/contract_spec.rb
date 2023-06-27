require_relative "../../bikes/contract"

RSpec.describe Bikes::Contract do
  subject(:contract) { described_class.new }

  describe "validation rules" do
    context "when all required attributes are present" do
      let(:valid_attributes) { {name: "Mountain Bike"} }

      it "passes validation" do
        expect(contract.call(valid_attributes)).to be_success
      end
    end

    context "when required attributes are missing" do
      let(:invalid_attributes) { {name: ""} }

      it "fails validation" do
        expect(contract.call(invalid_attributes)).to be_failure
      end

      it "includes an error message for the missing attribute" do
        result = contract.call(invalid_attributes)
        expect(result.errors.to_h).to include(name: ["must be filled"])
      end
    end
  end
end
