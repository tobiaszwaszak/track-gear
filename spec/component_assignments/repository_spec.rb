require_relative "../../db/records/component_assignment"
require_relative "../../component_assignments/repository"

RSpec.describe ComponentAssignments::Repository do
  let(:repository) { ComponentAssignments::Repository.new }

  describe "#create" do
    it "creates a new component assignment" do
      bike = Db::Records::Bike.create(name: "foo")
      component = Db::Records::Component.create(name: "bar")

      assignment = repository.create(bike_id: bike.id, component_id: component.id)

      expect(assignment.bike_id).to eq(bike.id)
      expect(assignment.component_id).to eq(component.id)
      expect(assignment.started_at.strftime("%F")).to eq(Time.now.strftime("%F"))
      expect(assignment.ended_at).to be_nil
    end
  end

  describe "#delete" do
    it "deletes an existing component assignment" do
      bike = Db::Records::Bike.create(name: "foo")
      component = Db::Records::Component.create(name: "bar")
      assignment = Db::Records::ComponentAssignment.create(bike_id: bike.id, component_id: component.id)

      repository.delete(bike_id: bike.id, component_id: component.id)

      assignment.reload
      expect(assignment.ended_at.strftime("%F")).to eq(Time.now.strftime("%F"))
    end

    it "raises RecordNotFound error when trying to delete non-existing assignment" do
      expect { repository.delete(bike_id: 999, component_id: 999) }.to raise_error(ComponentAssignments::RecordNotFound)
    end
  end
end
