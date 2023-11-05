require_relative "../spec_helper"

RSpec.describe App::Contracts::ComponentAssignment do
  subject(:contract) { described_class.new }

  describe "validations" do
    let(:params) { {bike_id: 1, component_id: 2} }

    it "passes when all required parameters are provided" do
      expect(contract.call(params)).to be_success
    end

    context "when bike_id is missing" do
      let(:params) { {component_id: 2} }

      it "fails " do
        result = contract.call(params)
        expect(result).to be_failure
        expect(result.errors.to_h).to eq({bike_id: ["is missing"]})
      end
    end

    context "when component_id is missing" do
      let(:params) { {bike_id: 1} }

      it "fails" do
        result = contract.call(params)
        expect(result).to be_failure
        expect(result.errors.to_h).to eq({component_id: ["is missing"]})
      end
    end

    context " when bike_id is not an integer" do
      let(:params) { {bike_id: "not_an_integer", component_id: 2} }

      it "fails" do
        result = contract.call(params)
        expect(result).to be_failure
        expect(result.errors.to_h).to eq({bike_id: ["must be an integer"]})
      end
    end

    context "when component_id is not an integer" do
      let(:params) { {bike_id: 1, component_id: "not_an_integer"} }

      it "fails" do
        result = contract.call(params)
        expect(result).to be_failure
        expect(result.errors.to_h).to eq({component_id: ["must be an integer"]})
      end
    end

    context "when started_at is an datetime" do
      let(:paams) { {bike_id: 1, component_id: 2, started_at: "2023-10-24 07:29:24"} }

      it "pass" do
        expect(contract.call(params)).to be_success
      end
    end

    context "when started_at is empty" do
      let(:params) { {bike_id: 1, component_id: 2, started_at: ""} }

      it "pass" do
        expect(contract.call(params)).to be_success
      end
    end

    context "when started_at is not an datetime" do
      let(:params) { {bike_id: 1, component_id: 2, started_at: "just string"} }

      it "fails" do
        result = contract.call(params)
        expect(result).to be_failure
        expect(result.errors.to_h).to eq({started_at: ["must be a date time"]})
      end
    end

    context "when ended_at is an datetime" do
      let(:params) { {bike_id: 1, component_id: 2, ended_at: "2023-10-24 07:29:24"} }

      it "pass" do
        expect(contract.call(params)).to be_success
      end
    end

    context "when ended_at is empty" do
      let(:params) { {bike_id: 1, component_id: 2, ended_at: ""} }

      it "pass" do
        expect(contract.call(params)).to be_success
      end
    end

    context "when ended_at is not an datetime" do
      let(:params) { {bike_id: 1, component_id: 2, ended_at: "just string"} }

      it "fails" do
        result = contract.call(params)
        expect(result).to be_failure
        expect(result.errors.to_h).to eq({ended_at: ["must be a date time"]})
      end
    end
  end
end
