require_relative "../../app/repositories/sport_types"
require_relative "../../app/records/sport_type"

RSpec.describe App::Repositories::SportTypes do
  let(:repository) { described_class.new }

  before(:all) do
    ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
    ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
  end

  after(:all) do
    ActiveRecord::Base.remove_connection
  end

  describe "#all" do
    it "returns a list of sport types" do
      sport_type1 = repository.create(name: "Test Sport Type 1")
      sport_type2 = repository.create(name: "Test Sport Type 2")

      all_sport_types = repository.all

      expect(all_sport_types).to include(
        a_hash_including(id: sport_type1[:id], name: sport_type1[:name]),
        a_hash_including(id: sport_type2[:id], name: sport_type2[:name])
      )
    end
  end

  describe "#create" do
    it "creates a new sport type" do
      new_sport_type = repository.create(name: "New Sport Type")
      expect(new_sport_type[:name]).to eq("New Sport Type")
    end
  end

  describe "#find" do
    it "finds an existing sport type by ID" do
      sport_type = repository.create(name: "Find Me")
      found_sport_type = repository.find(id: sport_type[:id])

      expect(found_sport_type).to include(
        id: sport_type[:id],
        name: sport_type[:name]
      )
    end

    it "raises RecordNotFound when sport type is not found" do
      expect { repository.find(id: 12345) }.to raise_error(App::Repositories::RecordNotFound)
    end
  end

  describe "#update" do
    it "updates an existing sport type" do
      sport_type = repository.create(name: "Update Me")
      updated_sport_type = repository.update(id: sport_type[:id], params: {name: "Updated Name"})

      expect(updated_sport_type[:name]).to eq("Updated Name")
    end

    it "raises RecordNotFound when sport type is not found for updating" do
      expect { repository.update(id: 12345, params: {name: "Invalid Update"}) }
        .to raise_error(App::Repositories::RecordNotFound)
    end
  end

  describe "#delete" do
    it "deletes an existing sport type" do
      sport_type = repository.create(name: "Delete Me")
      expect { repository.delete(id: sport_type[:id]) }.not_to raise_error
    end

    it "raises RecordNotFound when sport type is not found for deletion" do
      expect { repository.delete(id: 12345) }.to raise_error(App::Repositories::RecordNotFound)
    end
  end
end
