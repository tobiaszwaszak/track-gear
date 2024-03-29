require_relative "../spec_helper"

RSpec.describe App::Repositories::BikeSportTypes do
  let(:repository) { App::Repositories::BikeSportTypes.new }

  let!(:bike) { ::App::Records::Bike.create(name: "foo") }
  let!(:sport_type) { ::App::Records::SportType.create(name: "bar") }
  let!(:bike_sport_type) { repository.create(bike_id: bike.id, sport_type_id: sport_type.id) }

  describe "#create" do
    it "creates a new bike sport type" do
      expect(bike_sport_type.bike_id).to eq(bike.id)
      expect(bike_sport_type.sport_type_id).to eq(sport_type.id)
    end
  end

  describe "#delete" do
    it "deletes an existing bike sport type" do
      repository.delete(bike_id: bike.id, sport_type_id: sport_type.id)

      expect { repository.delete(bike_id: bike.id, sport_type_id: sport_type.id) }.to raise_error(App::Repositories::RecordNotFound)
    end
  end
end
