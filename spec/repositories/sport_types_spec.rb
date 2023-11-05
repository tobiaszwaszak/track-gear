require_relative "../spec_helper"

RSpec.describe App::Repositories::SportTypes do
  let(:repository) { described_class.new }
  let(:sport_type1) { repository.create(name: "Test Sport Type 1") }
  let(:sport_type2) { repository.create(name: "Test Sport Type 2") }

  describe "#all" do
    before do
      sport_type1
      sport_type2
    end

    it "returns a list of sport types" do
      expect(repository.all).to include(
        a_hash_including(id: sport_type1[:id], name: sport_type1[:name]),
        a_hash_including(id: sport_type2[:id], name: sport_type2[:name])
      )
    end
  end

  describe "#create" do
    subject(:new_sport_type) { repository.create(name: "New Sport Type")}

    it "creates a new sport type" do
      expect(new_sport_type[:name]).to eq("New Sport Type")
    end
  end

  describe "#find" do
    subject(:find_sport_type) { repository.find(id: request_id) }
    let(:request_id) { sport_type1[:id]}

    it "finds an existing sport type by ID" do
      expect(find_sport_type).to include(
        id: sport_type1[:id],
        name: sport_type1[:name]
      )
    end

    context "when sport type is not found" do
      let(:request_id) { 12345 }

      it "raises RecordNotFound" do
        expect { find_sport_type }.to raise_error(App::Repositories::RecordNotFound)
      end
    end
  end

  describe "#update" do
    subject(:update_sport_type) { repository.update(id: request_id, params: {name: "Updated Name"}) }
    let(:request_id) { sport_type1[:id] }
    it "updates an existing sport type" do
      expect(update_sport_type[:name]).to eq("Updated Name")
    end

    context "when sport type is not found for updating" do
      let(:request_id) { 1232131 }
      it "raises RecordNotFound" do
        expect { update_sport_type }.to raise_error(App::Repositories::RecordNotFound)
      end
    end
  end

  describe "#delete" do
    subject(:delete) {repository.delete(id: request_id) }
    let(:request_id) { sport_type1[:id] }

    it "deletes an existing sport type" do
      expect { delete }.not_to raise_error
    end

    context "when sport type is not found for deletion" do
      let(:request_id) { 1232131 }

      it "raises RecordNotFound" do
        expect { delete }.to raise_error(App::Repositories::RecordNotFound)
      end
    end
  end
end
