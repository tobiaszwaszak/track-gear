require_relative "../../db/records/component_assignment"
require_relative "../../component_assignments/repository"

RSpec.describe ComponentAssignments::Repository do
  let(:repository) { ComponentAssignments::Repository.new }

  describe "#create" do
    it "creates a new component assignment" do
      assignment = repository.create(bike_id: 1, component_id: 2)

      expect(assignment.bike_id).to eq(1)
      expect(assignment.component_id).to eq(2)
      expect(assignment.start_date).to eq(Date.today)
      expect(assignment.end_date).to be_nil
    end
  end

  describe "#delete" do
    it "deletes an existing component assignment" do
      assignment = Db::Records::ComponentAssignment.create(bike_id: 1, component_id: 1, start_date: Date.today)

      repository.delete(id: assignment.id)

      assignment.reload
      expect(assignment.end_date).to eq(Date.today)
    end

    it "raises RecordNotFound error when trying to delete non-existing assignment" do
      non_existing_id = 999
      expect { repository.delete(id: non_existing_id) }.to raise_error(ComponentAssignments::RecordNotFound)
    end
  end
end
