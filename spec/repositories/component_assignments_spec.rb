require_relative "../spec_helper"

RSpec.describe App::Repositories::ComponentAssignments do
  let(:repository) { App::Repositories::ComponentAssignments.new }

  let!(:bike) { ::App::Records::Bike.create(name: "foo") }
  let!(:component) { ::App::Records::Component.create(name: "bar") }
  let!(:assignment) { repository.create(bike_id: bike.id, component_id: component.id, started_at: nil, ended_at: nil) }

  before(:all) do
    ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
    ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
  end

  after(:all) do
    ActiveRecord::Base.remove_connection
  end

  describe "#create" do
    it "creates a new component assignment" do
      expect(assignment.bike_id).to eq(bike.id)
      expect(assignment.component_id).to eq(component.id)
      expect(assignment.started_at.strftime("%F")).to eq(Time.now.strftime("%F"))
      expect(assignment.ended_at).to be_nil
    end

    context "when srated_at is set" do
      let(:started_at) { "2023-10-24 07:29:24" }
      let(:assignment) { repository.create(bike_id: bike.id, component_id: component.id, started_at: started_at, ended_at: nil) }

      it "creates a new component assignment" do
        expect(assignment.started_at).to eq(started_at)
        expect(assignment.ended_at).to be_nil
      end
    end

    context "when ended_at is set" do
      let(:ended_at) { "2023-10-24 07:29:24" }
      let(:assignment) { repository.create(bike_id: bike.id, component_id: component.id, started_at: nil, ended_at: ended_at) }

      it "creates a new component assignment" do
        expect(assignment.started_at.strftime("%F")).to eq(Time.now.strftime("%F"))
        expect(assignment.ended_at).to eq(ended_at)
      end
    end
  end

  describe "#delete" do
    it "deletes an existing component assignment" do
      repository.delete(bike_id: bike.id, component_id: component.id, ended_at: nil)

      assignment.reload
      expect(assignment.ended_at.strftime("%F")).to eq(Time.now.strftime("%F"))
    end

    it "raises RecordNotFound error when trying to delete non-existing assignment" do
      expect { repository.delete(bike_id: 999, component_id: 999, ended_at: nil) }.to raise_error(::App::Repositories::RecordNotFound)
    end

    context "when ended_at is set" do
      let(:ended_at) { "2023-10-24 07:29:24" }

      it "deletes an existing component assignment" do
        repository.delete(bike_id: bike.id, component_id: component.id, ended_at: ended_at)

        assignment.reload
        expect(assignment.ended_at).to eq(ended_at)
      end
    end
  end
end
