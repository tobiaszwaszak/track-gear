require_relative "../../db/records/component"
require_relative "../../components/repository"

RSpec.describe Components::Repository do
  let(:repository) { Components::Repository.new }

  describe "#all" do
    it "returns all components" do
      expect(Db::Records::Component).to receive(:all)
      repository.all
    end
  end

  describe "#all_by" do
    it "returns components filtered by the given filters" do
      filters = { bike_id: 1, name: "Handlebar" }
      expect(Db::Records::Component).to receive(:where).with(filters)
      repository.all_by(filters)
    end
  end

  describe "#create" do
    it "creates a new component" do
      bike_id = 1
      name = "Handlebar"
      description = "A handlebar for bikes"
      expect(Db::Records::Component).to receive(:create).with(
        bike_id: bike_id,
        name: name,
        description: description
      )
      repository.create(bike_id: bike_id, name: name, description: description)
    end
  end

  describe "#find" do
    it "finds a component by id" do
      id = 1
      expect(Db::Records::Component).to receive(:find_by).with(id: id)
      repository.find(id: id)
    end
  end

  describe "#update" do
    it "updates a component with the given id and params" do
      id = 1
      params = { name: "Saddle" }
      record = double("record")
      allow(repository).to receive(:find).with(id: id).and_return(record)
      expect(record).to receive(:update).with(params)
      repository.update(id: id, params: params)
    end
  end

  describe "#delete" do
    it "deletes a component with the given id" do
      id = 1
      record = double("record")
      allow(repository).to receive(:find).with(id: id).and_return(record)
      expect(record).to receive(:destroy!)
      repository.delete(id: id)
    end
  end
end
